import 'package:flutter/material.dart';
import 'package:tradetrackr/core/extensions/context_extensions.dart';
import 'responsive_padding.dart';

/// A widget that constrains its child width on larger screens.
///
/// On desktop, this applies a max-width constraint to prevent content
/// from becoming too wide. On mobile and tablet, the child takes
/// the full available width.
///
/// Example:
/// ```dart
/// ResponsiveCenter(
///   child: Column(children: [...]),
/// )
/// ```
class ResponsiveCenter extends StatelessWidget {
  /// Creates a responsive center widget.
  const ResponsiveCenter({
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  /// The child widget to constrain.
  final Widget child;

  /// Custom max-width for desktop. If null, uses the default max content width
  /// from ContextExtensions (1200px for desktop).
  final double? maxWidth;

  /// Optional responsive padding to apply around the constrained content.
  final Widget? padding;

  /// How to align the child within the available space.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? context.maxContentWidth;

    final content = padding ?? child;

    return Align(
      alignment: alignment,
      child: Container(
        width: effectiveMaxWidth == double.infinity
            ? null
            : double.infinity,
        constraints: BoxConstraints(
          maxWidth: effectiveMaxWidth,
        ),
        child: content,
      ),
    );
  }
}

/// A widget that centers content with a fixed width on larger screens.
///
/// Unlike [ResponsiveCenter] which is for general content, this is
/// specifically for content that should always have a centered layout
/// on tablet and desktop, such as forms and settings pages.
///
/// Example:
/// ```dart
/// ResponsiveCentered(
///   child: SettingsForm(),
/// )
/// ```
class ResponsiveCentered extends StatelessWidget {
  /// Creates a responsive centered widget.
  const ResponsiveCentered({
    required this.child,
    this.maxWidth = 600,
    this.padding,
    super.key,
  });

  /// The child widget to center.
  final Widget child;

  /// Maximum width for the centered content. Defaults to 600px.
  final double maxWidth;

  /// Optional responsive padding to apply around the content.
  final Widget? padding;

  @override
  Widget build(BuildContext context) {
    final content = padding ?? child;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: content,
      ),
    );
  }
}

/// A scaffold that applies responsive centering to its body.
///
/// This is particularly useful for pages that should have centered
/// content on all screen sizes, such as auth pages and settings.
///
/// Example:
/// ```dart
/// ResponsiveScaffold(
///   appBar: AppBar(title: Text('Settings')),
///   body: SettingsContent(),
/// )
/// ```
class ResponsiveScaffold extends StatelessWidget {
  /// Creates a responsive scaffold.
  const ResponsiveScaffold({
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    super.key,
  });

  /// See [Scaffold.appBar].
  final PreferredSizeWidget? appBar;

  /// The primary content of the scaffold.
  final Widget? body;

  /// See [Scaffold.bottomNavigationBar].
  final Widget? bottomNavigationBar;

  /// See [Scaffold.floatingActionButton].
  final Widget? floatingActionButton;

  /// See [Scaffold.backgroundColor].
  final Color? backgroundColor;

  /// See [Scaffold.resizeToAvoidBottomInset].
  final bool resizeToAvoidBottomInset;

  /// See [Scaffold.extendBody].
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBody: extendBody,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: body != null
          ? ResponsiveCenter(
              child: ResponsivePadding(
                horizontal: true,
                vertical: false,
                child: body!,
              ),
            )
          : null,
    );
  }
}
