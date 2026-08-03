import 'package:flutter/material.dart';

import '../grammar_content.dart';
import '../i18n.dart';
import '../language_course.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

/// Overzicht van de grammaticacategorieën van de huidige cursus, gebundeld
/// per onderwerp zodat je ze rustig kan doorlezen.
class GrammarScreen extends StatelessWidget {
  final Strings t;
  final Lang lang;
  final LanguageCourse course;

  const GrammarScreen({
    super.key,
    required this.t,
    required this.lang,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final nl = lang == Lang.nl;
    final categories = course.grammarCategories;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.grammarTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                t.grammarSubtitle,
                style: TextStyle(fontSize: 12, color: palette.muted),
              ),
            ],
          ),
        ),
        Expanded(
          child: categories.isEmpty
              ? Center(
                  child: Text(
                    t.grammarEmpty,
                    style: TextStyle(fontSize: 14, color: palette.muted),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final category = categories[i];
                    return _CategoryCard(
                      t: t,
                      nl: nl,
                      category: category,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GrammarCategoryScreen(
                            t: t,
                            nl: nl,
                            course: course,
                            category: category,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Strings t;
  final bool nl;
  final GrammarCategory category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.t,
    required this.nl,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title(nl),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.grammarRuleCount(category.rules.length),
                      style: TextStyle(fontSize: 12, color: palette.muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 16, color: palette.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// De regels binnen één grammaticacategorie, uitklapbaar zoals de
/// woordenlijst.
class GrammarCategoryScreen extends StatefulWidget {
  final Strings t;
  final bool nl;
  final LanguageCourse course;
  final GrammarCategory category;

  const GrammarCategoryScreen({
    super.key,
    required this.t,
    required this.nl,
    required this.course,
    required this.category,
  });

  @override
  State<GrammarCategoryScreen> createState() => _GrammarCategoryScreenState();
}

class _GrammarCategoryScreenState extends State<GrammarCategoryScreen> {
  int? _expanded;

  @override
  Widget build(BuildContext context) {
    final rules = widget.category.rules;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  BackButtonCard(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.category.title(widget.nl),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: rules.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _RuleCard(
                  nl: widget.nl,
                  course: widget.course,
                  rule: rules[i],
                  expanded: _expanded == i,
                  onTap: () =>
                      setState(() => _expanded = _expanded == i ? null : i),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  final bool nl;
  final LanguageCourse course;
  final GrammarRule rule;
  final bool expanded;
  final VoidCallback onTap;

  const _RuleCard({
    required this.nl,
    required this.course,
    required this.rule,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      rule.title(nl),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: palette.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rule.body(nl),
                          style: TextStyle(
                            fontSize: 13,
                            color: palette.foreground,
                            height: 1.4,
                          ),
                        ),
                        if (rule.examples.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          for (final example in rule.examples)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          example.$1,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          nl ? example.$2 : example.$3,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: palette.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SpeakButton(
                                    text: example.$1,
                                    locale: course.ttsLocale,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
