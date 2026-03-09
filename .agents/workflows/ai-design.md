---
description: Rules for maintaining the AIko (Intelligent Companion) design system
---

# AIko Design Rules (Workflow)

To ensure consistency in future "AIko" screens, follow these steps:

## 1. Theme and Colors
- ALWAYS use `AppTheme.premiumGradient` for page backgrounds.
- PRIMARY ACTION: Use `AppTheme.accentCyan` (#00FBFF) with a neon glow effect.
- SECONDARY/ERROR: Use `AppTheme.accentMagenta` (#FF00FF).
- TEXT: Use `AppTheme.textPrimary` for maximum contrast, `textSecondary` for metadata.

## 2. Component Structure (Glassmorphism)
- Wrap cards in `Container` with:
    - `color: Colors.white.withOpacity(0.08)`
    - `borderRadius: BorderRadius.circular(20)`
    - `Border.all(color: Colors.white.withOpacity(0.12))`
- Buttons should be pill-shaped (`BorderRadius.circular(30)`).

## 3. Animations (Intelligence Feel)
- Use `flutter_animate` for all transitions.
- Interactive elements should have a "breathing" effect:
    ```dart
    .animate(onPlay: (c) => c.repeat(reverse: true))
    .shimmer(duration: 4.s, color: accentColor.withOpacity(0.1))
    ```

## 4. Layout
- Use `SafeArea` and `Padding(padding: EdgeInsets.all(24))`.
- Avoid fixed heights; use `Expanded` or `Flexible` with `SingleChildScrollView` to prevent overflows.

## 5. Tone of Voice
- The UI should feel like a "Personal AI Assistant".
- Use `Icons.auto_awesome_rounded` or similar AI-inspired icons.
