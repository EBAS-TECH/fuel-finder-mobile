import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:fuel_finder/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_bloc.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_event.dart';
import 'package:fuel_finder/features/feedback/presentation/bloc/feed_back_state.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';
import 'package:fuel_finder/features/map/presentation/widgets/explore_widgets/station_info_card.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StationDetailPage extends StatefulWidget {
  final Map<String, dynamic> station;
  final double? distance;
  final double? duration;
  const StationDetailPage({
    super.key,
    required this.station,
    this.distance,
    this.duration,
  });

  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  int _userRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isFavorite = false;
  bool _hasExistingFeedback = false;
  bool _isEditing = false;
  int _originalRating = 0;
  String _originalComment = '';

  @override
  void didUpdateWidget(StationDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.station["id"] != widget.station["id"]) {
      context.read<FeedBackBloc>().add(ResetFeedBackEvent());
      _resetFeedbackState();
      _fetchFeedBack();
    }
  }

  void _resetFeedbackState() {
    setState(() {
      _userRating = 0;
      _commentController.clear();
      _hasExistingFeedback = false;
      _isEditing = false;
      _originalRating = 0;
      _originalComment = '';
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final stationData = widget.station["data"] ?? widget.station;
    _isFavorite = stationData['isFavorite'] == true;
    _fetchFeedBack();
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() {
    context.read<FavoriteBloc>().add(GetFavoritesEvent());
  }

  void _fetchFeedBack() {
    context.read<FeedBackBloc>().add(
      GetFeedBackByStationAndUserEvent(stationId: widget.station["id"]),
    );
  }

  Future<void> _submitFeedback() async {
    final localizations = AppLocalizations.of(context);
    final trimmedComment = _commentController.text.trim();
    if (_userRating == 0 && trimmedComment.isEmpty) {
      ShowSnackbar.show(
        context,
        localizations?.feedbackEmptyError ??
            "Please provide a rating or comment",
        isError: true,
      );
      return;
    }

    final confirmed = await _showConfirmationDialog(
      context,
      _isEditing
          ? localizations?.updateFeedbackTitle ?? 'Update Feedback'
          : localizations?.submitFeedbackTitle ?? 'Submit Feedback',
      _isEditing
          ? localizations?.updateFeedbackConfirmation ??
              'Are you sure you want to update your feedback?'
          : localizations?.submitFeedbackConfirmation ??
              'Are you sure you want to submit your feedback?',
    );

    if (confirmed) {
      context.read<FeedBackBloc>().add(
        CreateFeedBackEvent(
          stationId: widget.station["id"],
          rating: _userRating,
          comment: trimmedComment,
        ),
      );
    }
  }

  Future<bool> _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
  ) async {
    final localizations = AppLocalizations.of(context);
    return (await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(localizations?.cancel ?? 'Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(localizations?.confirm ?? 'Confirm'),
                  ),
                ],
              ),
        )) ??
        false;
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _originalRating = _userRating;
      _originalComment = _commentController.text;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _userRating = _originalRating;
      _commentController.text = _originalComment;
    });
  }

  void _toggleFavorite() {
    final stationId = widget.station["id"];
    if (_isFavorite) {
      context.read<FavoriteBloc>().add(
        RemoveFavoriteEvent(stationId: stationId),
      );
      setState(() {
        _isFavorite = false;
      });
    } else {
      context.read<FavoriteBloc>().add(SetFavoriteEvent(stationId: stationId));
      setState(() {
        _isFavorite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final station = widget.station;
    final stationData = station["data"] ?? station;
    final isSuggestion = stationData['suggestion'] == true;
    final distance = stationData['distance'] as double?;
    final availableFuel = stationData['available_fuel'] as List<dynamic>?;
    final averageRate = stationData['averageRate']?.toString() ?? '0';
    final imageIndex =
        (stationData['name']?.hashCode ?? 0).abs() %
        StationInfoCard.stationImages.length;

    return BlocListener<FavoriteBloc, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteSucess) {
          ShowSnackbar.show(context, state.message);
        } else if (state is FavoriteFailure) {
          setState(() {
            _isFavorite = !_isFavorite;
          });
          ShowSnackbar.show(context, state.error, isError: true);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: localizations?.stationDetailsTitle ?? "Fuel Station Details",
          centerTitle: true,
        ),
        body: BlocConsumer<FeedBackBloc, FeedBackState>(
          listener: (context, state) {
            if (state is FeedBackSucess) {
              ShowSnackbar.show(context, state.message);

              if (state.feedback != null && state.feedback!['data'] != null) {
                final feedbackData = state.feedback!['data'];
                setState(() {
                  _hasExistingFeedback = true;
                  _userRating = feedbackData['rating'] ?? 0;
                  _commentController.text = feedbackData['comment'] ?? '';
                  _isEditing = false;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is FeedBackFetchSucess) {
              final feedbackData = state.feedback['data'];
              if (feedbackData != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!_hasExistingFeedback) {
                    setState(() {
                      _hasExistingFeedback = true;
                      _userRating = feedbackData['rating'] ?? 0;
                      _commentController.text = feedbackData['comment'] ?? '';
                      _originalRating = _userRating;
                      _originalComment = _commentController.text;
                    });
                  }
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_hasExistingFeedback) {
                    setState(() {
                      _hasExistingFeedback = false;
                      _isEditing = false;
                      _userRating = 0;
                      _commentController.clear();
                    });
                  }
                });
              }
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      leading: Image.asset(
                        StationInfoCard.stationImages[imageIndex],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            station['name'] ??
                                localizations?.gasStation ??
                                'Gas Station',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isSuggestion)
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 10),
                                Text(
                                  localizations?.suggested ?? "Suggested",
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (station['averageRate'] != null)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        averageRate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.local_gas_station,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      availableFuel?.join(', ') ??
                                          localizations?.noFuelInfo ??
                                          'No fuel information',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppPallete.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (distance != null && distance >= 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.blue,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${distance.toStringAsFixed(1)} ${localizations?.distanceUnit ?? 'km'}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color:
                                        _isFavorite ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () {
                                    _toggleFavorite();
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations?.yourRatingLabel ?? 'Your Rating',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_hasExistingFeedback && !_isEditing)
                        TextButton(
                          onPressed: _startEditing,
                          child: Text(localizations?.editButton ?? 'Edit'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          if (!_hasExistingFeedback || _isEditing) {
                            setState(() {
                              _userRating = index + 1;
                            });
                          }
                        },
                        child: Icon(
                          index < _userRating ? Icons.star : Icons.star_border,
                          color:
                              (_hasExistingFeedback && !_isEditing)
                                  ? Colors.amber.withOpacity(0.5)
                                  : Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  if (_hasExistingFeedback && !_isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        localizations?.ratedMessage ?? 'You rated this station',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  Text(
                    localizations?.yourCommentLabel ?? 'Your Comment',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    readOnly: _hasExistingFeedback && !_isEditing,
                    decoration: InputDecoration(
                      hintText:
                          (_hasExistingFeedback && !_isEditing)
                              ? ''
                              : localizations?.commentHint ??
                                  'Share your experience...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppPallete.primaryColor),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  if (!_hasExistingFeedback || _isEditing)
                    Row(
                      children: [
                        if (_isEditing)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _cancelEditing,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              child: Text(localizations?.cancel ?? 'Cancel'),
                            ),
                          ),
                        if (_isEditing) const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitFeedback,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _isEditing
                                  ? localizations?.updateButton ?? 'Update'
                                  : localizations?.submitButton ?? 'Submit',
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

