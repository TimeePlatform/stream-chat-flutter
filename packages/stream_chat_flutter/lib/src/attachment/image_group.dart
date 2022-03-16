import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/fullscreen_media/full_screen_media_desktop.dart'
    hide ShowMessageCallback, ReturnActionType;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget for constructing a group of images in message
class ImageGroup extends StatelessWidget {
  /// Constructor for creating [ImageGroup] widget
  const ImageGroup({
    Key? key,
    required this.images,
    required this.message,
    required this.messageTheme,
    required this.size,
    this.onReturnAction,
    this.onShowMessage,
    this.onAttachmentTap,
  }) : super(key: key);

  /// List of attachments to show
  final List<Attachment> images;

  /// Callback when attachment is returned to from other screens
  final ValueChanged<ReturnActionType>? onReturnAction;

  /// Callback when attachment is tapped
  final void Function(Message message, Attachment attachment)? onAttachmentTap;

  /// Message which images are attached to
  final Message message;

  /// [MessageThemeData] to apply to message
  final MessageThemeData messageTheme;

  /// Size of images
  final Size size;

  /// Callback for when show message is tapped
  final ShowMessageCallback? onShowMessage;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(size),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              direction: Axis.horizontal,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: _buildImage(context, 0),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: _buildImage(context, 1),
                  ),
                ),
              ],
            ),
          ),
          if (images.length >= 3)
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: _buildImage(context, 2),
                    ),
                    if (images.length >= 4)
                      Flexible(
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              _buildImage(context, 3),
                              if (images.length > 4)
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => _onTap(context, 3),
                                    child: Material(
                                      color: Colors.black38,
                                      child: Center(
                                        child: Text(
                                          '+ ${images.length - 4}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onTap(
    BuildContext context,
    int index,
  ) async {
    if (onAttachmentTap != null) {
      return onAttachmentTap!(message, images[index]);
    }

    final channel = StreamChannel.of(context).channel;

    final res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StreamChannel(
          channel: channel,
          child: PlatformWidgetBuilder(
            mobile: (context, child) => FullScreenMediaMobile(
              mediaAttachments: images,
              startIndex: index,
              userName: message.user?.name,
              message: message,
              onShowMessage: onShowMessage,
            ),
            desktop: (context, child) => FullScreenMediaDesktop(
              mediaAttachments: images,
              startIndex: index,
              userName: message.user?.name,
              message: message,
              onShowMessage: onShowMessage,
              autoplayVideos: true,
            ),
          ),
        ),
      ),
    );
    if (res != null) onReturnAction?.call(res);
  }

  Widget _buildImage(BuildContext context, int index) {
    return ImageAttachment(
      attachment: images[index],
      size: size,
      message: message,
      messageTheme: messageTheme,
      onAttachmentTap: () => _onTap(context, index),
    );
  }
}