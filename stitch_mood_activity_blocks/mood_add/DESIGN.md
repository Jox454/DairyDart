---
name: Lumina Mood & Activity
colors:
  surface: '#091421'
  surface-dim: '#091421'
  surface-bright: '#303a48'
  surface-container-lowest: '#050f1c'
  surface-container-low: '#121c2a'
  surface-container: '#16202e'
  surface-container-high: '#212b39'
  surface-container-highest: '#2b3544'
  on-surface: '#d9e3f6'
  on-surface-variant: '#cbc3d7'
  inverse-surface: '#d9e3f6'
  inverse-on-surface: '#27313f'
  outline: '#958ea0'
  outline-variant: '#494454'
  surface-tint: '#d0bcff'
  primary: '#d0bcff'
  on-primary: '#3c0091'
  primary-container: '#a078ff'
  on-primary-container: '#340080'
  inverse-primary: '#6d3bd7'
  secondary: '#adc6ff'
  on-secondary: '#002e6a'
  secondary-container: '#0566d9'
  on-secondary-container: '#e6ecff'
  tertiary: '#ffafd3'
  on-tertiary: '#620040'
  tertiary-container: '#e364a7'
  on-tertiary-container: '#560038'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e9ddff'
  primary-fixed-dim: '#d0bcff'
  on-primary-fixed: '#23005c'
  on-primary-fixed-variant: '#5516be'
  secondary-fixed: '#d8e2ff'
  secondary-fixed-dim: '#adc6ff'
  on-secondary-fixed: '#001a42'
  on-secondary-fixed-variant: '#004395'
  tertiary-fixed: '#ffd8e7'
  tertiary-fixed-dim: '#ffafd3'
  on-tertiary-fixed: '#3d0026'
  on-tertiary-fixed-variant: '#85145a'
  background: '#091421'
  on-background: '#d9e3f6'
  surface-variant: '#2b3544'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
  body-lg:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 8px
  sm: 16px
  md: 24px
  lg: 32px
  xl: 48px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 64px
---

## Brand & Style

The design system is centered around a **Modern Corporate** aesthetic with **Glassmorphic** refinements. It aims to evoke a sense of calm, focus, and clarity for users tracking their mental health and daily habits. The interface utilizes a deep, immersive charcoal foundation to reduce eye strain, while employing vibrant purple and blue accents to denote progress and positive reinforcement.

The emotional response should be one of "supported introspection"—a professional yet approachable environment where data feels readable and emotions feel manageable. Visuals are characterized by soft-touch surfaces, subtle transparency, and high-quality, colorful iconography that provides clear cognitive anchors for different activities.

## Colors

This design system utilizes a sophisticated dark palette designed for high-contrast readability. 

- **Primary (Vibrant Purple):** Used for primary actions, active states, and "high energy" mood indicators.
- **Secondary (Deep Sky Blue):** Used for informational accents, calm mood indicators, and secondary navigation elements.
- **Tertiary (Soft Pink):** Reserved for highlights, discounts (as seen in IMAGE_1), or urgent notifications.
- **Neutral (Charcoal & Slate):** A tiered system of greys scales from a deep `#111827` background to lighter `#374151` surface containers to create depth without relying on pure black.

## Typography

The typography strategy balances the friendly, open curves of **Plus Jakarta Sans** for headings with the systematic, highly legible character of **Manrope** for functional text. 

Headlines use a bold weight and slightly tighter letter spacing to create a strong visual anchor on onboarding and dashboard screens. Body text maintains generous line heights (1.5x+) to ensure long-form journaling or activity descriptions are easy to digest against the dark background. On mobile, headlines scale down slightly to prevent awkward text wrapping while maintaining their relative visual weight.

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for mobile-first consumption, inspired by the vertical stack and center-aligned focus of IMAGE_2.

- **Mobile:** A 4-column grid with 20px side margins. Elements like cards and buttons generally span the full width of the safe area.
- **Tablet/Desktop:** A 12-column grid with 64px margins. Content is often contained within a maximum width of 1024px to maintain readability.
- **Rhythm:** An 8pt spatial system governs all padding and margins. Vertical rhythm is strictly enforced to ensure that the "stacked list" view (as seen in IMAGE_1) feels organized and intentional.

## Elevation & Depth

This design system avoids heavy shadows in favor of **Tonal Layers** and **Glassmorphism**.

1.  **Foundational Layer:** Deep Charcoal (`#111827`) backdrop.
2.  **Container Layer:** Surface cards use a slightly lighter grey (`#1F2937`) with a subtle 1px border (`#374151`) to define edges.
3.  **Glassmorphic Overlay:** For floating elements like language selectors or navigation bars, a semi-transparent blur (Backdrop Filter: blur 12px) is used with a 10% white tint.
4.  **Accent Elevation:** Primary buttons use a vibrant purple fill with a soft, same-color glow (Shadow: 0 4px 14px rgba(139, 92, 246, 0.3)) to signify interactability.

## Shapes

The shape language is consistently **Rounded**. 

Standard UI components like input fields and list items use a 0.5rem (8px) radius. Larger containers, such as the feature list card in IMAGE_1, utilize a "rounded-lg" (16px) or "rounded-xl" (24px) radius to create a soft, friendly silhouette. Onboarding buttons (as seen in IMAGE_2) should lean towards a pill-shape or a very high radius (32px+) to emphasize their primary role in the user journey.

## Components

- **Buttons:** Primary buttons are high-saturation (Purple or Blue) with bold white text. Secondary buttons use the "ghost" style—transparent background with a 1px border.
- **Chips:** Used for mood tagging. These should be semi-transparent with icons, using the "soft" roundedness (4px-8px).
- **Cards:** Incorporate a subtle gradient or glassmorphic blur when overlaying illustrations. 
- **Input Fields:** Darker than the surface color, with a clear 2px border highlight when focused in the primary purple.
- **Icons:** Use a "duotone" or "colorful" style as seen in IMAGE_1. Each icon category should have a distinct color (e.g., green for export, blue for calendar) to aid in rapid visual scanning.
- **Language Selector:** A specific component from IMAGE_2; it should appear as a transparent glass button with a small chevron, triggering a bottom sheet or centered modal on tap.