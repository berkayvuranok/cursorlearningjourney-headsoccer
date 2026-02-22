---
name: base-pattern-documentation
description: Creates comprehensive documentation for base pattern classes following Flutter architecture conventions. Use when documenting new base classes, view patterns, state management patterns, or architectural components that serve as foundations for other code.
---

# Base Pattern Documentation

## Purpose

Guideline for consistent, comprehensive documentation of base pattern classes and architectural components. Base patterns are foundational classes that other code extends, such as `BaseView`, `BaseViewModel`, `MasterView`, etc.

## Header Structure

```dart
/// 🌟
/// [ClassName] is a [brief description of what it is and its primary purpose].
/// [Additional context about when and why to use it].
///
/// Example usage:
/// ```dart
/// [Concrete example showing typical usage]
/// ```
///
/// Features:
/// - 🔗 [Feature 1]
/// - 🛡️ [Feature 2]
/// - 🧩 [Feature 3]
class [ClassName] {
```

**Guidelines:**
- Start with 🌟 emoji for base classes
- Provide a clear one-sentence description
- Include a complete, runnable example
- List 3-5 key features with emojis

## Checklist

- [ ] Clear one-sentence description in header
- [ ] Complete, runnable code example
- [ ] 3-5 key features listed with emojis
- [ ] All public parameters documented
- [ ] Generic type parameters explained
- [ ] Extension points clearly marked (abstract methods, callbacks)
