import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template userAvatarTransform}
/// Transforms a [UserAvatar] according to the specified translation.
///
/// Used in [MessageWidgetContent].
/// {@endtemplate}
class UserAvatarTransform extends StatelessWidget {
  /// {@macro userAvatarTransform}
  const UserAvatarTransform({
    Key? key,
    required this.translateUserAvatar,
    required this.messageTheme,
    required this.message,
    this.userAvatarBuilder,
    this.onUserAvatarTap,
  }) : super(key: key);

  /// {@macro translateUserAvatar}
  final bool translateUserAvatar;

  /// {@macro messageTheme}
  final MessageThemeData messageTheme;

  /// {@macro userAvatarBuilder}
  final Widget Function(BuildContext, User)? userAvatarBuilder;

  /// {@macro message}
  final Message message;

  /// {@macro onUserAvatarTap}
  final void Function(User)? onUserAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        0,
        translateUserAvatar
            ? (messageTheme.avatarTheme?.constraints.maxHeight ?? 40) / 2
            : 0,
      ),
      child: userAvatarBuilder?.call(context, message.user!) ??
          UserAvatar(
            user: message.user!,
            onTap: onUserAvatarTap,
            constraints: messageTheme.avatarTheme!.constraints,
            borderRadius: messageTheme.avatarTheme!.borderRadius,
            showOnlineStatus: false,
          ),
    );
  }
}
