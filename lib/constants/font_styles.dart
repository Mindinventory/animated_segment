part of animated_segment;

/// [AppFontStyles] class have all the static and const members.
/// Here, we have defined used TextStyle inside the package.
class AppFontStyles {
  static const TextStyle textNormal = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Dimens.textNormal,
    color: AppColors.primary,
    overflow: TextOverflow.ellipsis,
  );
}
