# AIko Design System & Rules

This document defines the visual and interaction rules for the AIko application to ensure consistency across all future screens.

## 1. Core Visual Language
- **Theme:** Futuristic, Intelligent, Clean, Cyberpunk-lite.
- **Backgrounds:** Always use `AppTheme.premiumGradient` for main screens. Avoid solid flat backgrounds.
- **Colors:**
  - Primary: `Cyber Navy` (#050B18)
  - Accents: `Neon Cyan` (#00FBFF) for main actions, `Vibrant Magenta` (#FF00FF) for secondary/error states.
  - Surface: Use transparency and `glassWhite` (#1AFFFFFF) for cards.

## 2. Typography
- **Primary Font:** `Outfit` (via Google Fonts).
- **Japanese Font:** `Noto Sans JP`.
- **Headers:** Use `FontWeight.w800` for display titles to give a bold, high-tech feel.

## 3. UI Components (Glassmorphism)
- **Cards:** 
  - `Border.all(color: Colors.white.withOpacity(0.12))`
  - `borderRadius: BorderRadius.circular(20)`
  - `BoxShadow` with blur radius > 10 and 20% opacity black.
- **Buttons:** 
  - Primary buttons must be pill-shaped (`BorderRadius.circular(30)`).
  - Use `AppTheme.accentCyan` for primary buttons.

## 4. Animations & Micro-interactions
- **Breathing Effect:** Interactive elements (buttons, active cards) should have a subtle "breathing" scale or glow animation using `flutter_animate`.
  - *Example:* `.animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 3.s)`
- **Transitions:** Use `AnimatedSwitcher` or `Hero` with `Curves.easeInOutExpo` for screen/state changes.
- **Feedback:** Success states should use Cyan glow; Error states should use Magenta glow.

## 5. Layout Rules
- **Spacing:** Use a base of 8px (8, 16, 24, 32, 48).
- **Safe Areas:** Always wrap main content in `SafeArea`.
- **Focus:** Keep the center of the screen clear for the primary interaction (e.g., the character or the quiz question).

---
*Follow these rules strictly to maintain the AIko "Intelligent Companion" identity.*
