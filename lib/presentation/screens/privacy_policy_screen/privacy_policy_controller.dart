import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;

enum PrivacyPolicyBlockType { paragraph, heading, list }

class PrivacyPolicyBlock {
  final PrivacyPolicyBlockType type;
  final String text;
  final List<String> items;
  final bool ordered;
  final bool centered;
  final bool contact;

  const PrivacyPolicyBlock({
    required this.type,
    this.text = '',
    this.items = const [],
    this.ordered = false,
    this.centered = false,
    this.contact = false,
  });
}

class PrivacyPolicySection {
  final IconData icon;
  final String title;
  final List<PrivacyPolicyBlock> blocks;

  const PrivacyPolicySection({
    required this.icon,
    required this.title,
    required this.blocks,
  });
}

class PrivacyPolicyController extends GetxController {
  PrivacyPolicyController({
    AssetBundle? bundle,
    this.documentAsset = assetPath,
    this.documentName = 'privacy policy',
  }) : _bundle = bundle ?? rootBundle;

  final String documentAsset;
  final String documentName;
  final AssetBundle _bundle;
  bool _loadInProgress = false;

  static const assetPath = 'assets/html/privacy_policy.html';

  final pageTitle = ''.obs;
  final subtitle = ''.obs;
  final headerBlocks = <PrivacyPolicyBlock>[].obs;
  final sections = <PrivacyPolicySection>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPolicy();
  }

  Future<void> loadPolicy() async {
    if (_loadInProgress || isClosed) return;
    _loadInProgress = true;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final source = await _bundle.loadString(documentAsset, cache: false);
      if (!isClosed) _parsePolicy(source);
    } catch (_) {
      if (!isClosed) {
        errorMessage.value =
            'The $documentName could not be loaded. Please try again.';
      }
    } finally {
      _loadInProgress = false;
      if (!isClosed) isLoading.value = false;
    }
  }

  void _parsePolicy(String source) {
    final body = html_parser.parse(source).body;
    if (body == null) throw const FormatException('Missing policy body.');

    final parsedSections = <PrivacyPolicySection>[];
    final parsedHeaderBlocks = <PrivacyPolicyBlock>[];
    var parsedTitle = '';
    var parsedSubtitle = '';
    String? sectionTitle;
    final sectionBlocks = <PrivacyPolicyBlock>[];

    void finishSection() {
      if (sectionTitle == null) return;
      parsedSections.add(
        PrivacyPolicySection(
          icon: _iconFor(sectionTitle!),
          title: sectionTitle!,
          blocks: List.unmodifiable(sectionBlocks),
        ),
      );
      sectionTitle = null;
      sectionBlocks.clear();
    }

    void visit(html_dom.Node node) {
      if (node is! html_dom.Element) return;
      final tag = node.localName;
      if (tag == 'style' || tag == 'script') return;
      if (tag == 'div' && node.classes.contains('subtitle')) {
        parsedSubtitle = _text(node);
        return;
      }

      switch (tag) {
        case 'h1':
          parsedTitle = _text(node);
        case 'h2':
          finishSection();
          sectionTitle = _text(node);
        case 'h3':
          _addBlock(
            sectionTitle,
            sectionBlocks,
            parsedHeaderBlocks,
            PrivacyPolicyBlock(
              type: PrivacyPolicyBlockType.heading,
              text: _text(node),
            ),
          );
        case 'p':
          final text = _text(node);
          if (text.isNotEmpty) {
            _addBlock(
              sectionTitle,
              sectionBlocks,
              parsedHeaderBlocks,
              PrivacyPolicyBlock(
                type: PrivacyPolicyBlockType.paragraph,
                text: text,
                centered: node.classes.contains('meta'),
                contact: node.classes.contains('contact'),
              ),
            );
          }
        case 'ul' || 'ol':
          final items = node.children
              .where((child) => child.localName == 'li')
              .map((item) => _text(item))
              .where((item) => item.isNotEmpty)
              .toList();
          if (items.isNotEmpty) {
            _addBlock(
              sectionTitle,
              sectionBlocks,
              parsedHeaderBlocks,
              PrivacyPolicyBlock(
                type: PrivacyPolicyBlockType.list,
                items: items,
                ordered: tag == 'ol',
              ),
            );
          }
        default:
          for (final child in node.nodes) {
            visit(child);
          }
      }
    }

    for (final node in body.nodes) {
      visit(node);
    }
    finishSection();
    if (parsedTitle.isEmpty ||
        parsedSections.isEmpty ||
        parsedSections.any(
          (section) => section.title.isEmpty || section.blocks.isEmpty,
        )) {
      throw const FormatException('Privacy policy content is incomplete.');
    }
    pageTitle.value = parsedTitle;
    subtitle.value = parsedSubtitle;
    headerBlocks.assignAll(parsedHeaderBlocks);
    sections.assignAll(parsedSections);
  }

  void _addBlock(
    String? title,
    List<PrivacyPolicyBlock> sectionBlocks,
    List<PrivacyPolicyBlock> headerBlocks,
    PrivacyPolicyBlock block,
  ) {
    (title == null ? headerBlocks : sectionBlocks).add(block);
  }

  String _text(html_dom.Element element) =>
      element.text.replaceAll(RegExp(r'\s+'), ' ').trim();

  IconData _iconFor(String title) {
    final value = title.toLowerCase();
    if (value.contains('about')) return Icons.business_outlined;
    if (value.contains('information') || value.contains('account')) {
      return Icons.person_outline_rounded;
    }
    if (value.contains('payment')) return Icons.payment_outlined;
    if (value.contains('location')) return Icons.location_on_outlined;
    if (value.contains('technician')) return Icons.handyman_outlined;
    if (value.contains('marketing') || value.contains('advertising')) {
      return Icons.campaign_outlined;
    }
    if (value.contains('security')) return Icons.shield_outlined;
    if (value.contains('children')) return Icons.child_care_rounded;
    if (value.contains('contact')) return Icons.mail_outline_rounded;
    return Icons.policy_outlined;
  }
}
