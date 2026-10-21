import 'package:get/get.dart' hide Response;

/// Catalog transcribed from the supplied plan references. Prices are strings
/// to preserve quoted amounts rather than infer a billing formula.
class PlanPrice {
  const PlanPrice(this.annual, this.monthly);
  final String annual;
  final String monthly;
}

class SupportPlan {
  const SupportPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.prices,
    required this.features,
    this.bestDeal = false,
    this.quarterlyTickets,
  });
  final String id;
  final String name;
  final String description;
  final Map<int, PlanPrice> prices;
  final List<String> features;
  final bool bestDeal;
  final int? quarterlyTickets;

  List<String> benefits(int years) => [
    ...features,
    if (quarterlyTickets != null) ...[
      '${quarterlyTickets! * 4 * years} tickets · $quarterlyTickets per quarter',
      '1 onboarding · non-refundable',
    ],
  ];
}

final residentialPlans = [
  SupportPlan(
    id: 'smart',
    name: 'Smart SOS',
    description: "Everyday support for primary & peripheral devices.".tr,
    prices: {
      1: PlanPrice('1,125', '112.50'),
      2: PlanPrice('2,250', '225'),
      3: PlanPrice('3,375', '337.50'),
    },
    quarterlyTickets: 1,
    features: [
      'Covers phones and tablets',
      'Chat support · 5-minute response target',
      'Carbonite data backup',
      'Support · 9 AM–5 PM EST',
    ],
  ),
  SupportPlan(
    id: 'pro',
    name: 'Pro SOS',
    description:
        "Covers 3 devices: laptops, desktops, printers, phones & more.".tr,
    bestDeal: true,
    prices: {
      1: PlanPrice('1,725', '172.50'),
      2: PlanPrice('3,795', '379.50'),
      3: PlanPrice('6,210', '621'),
    },
    quarterlyTickets: 2,
    features: [
      'Security for 5 devices',
      'Covers printer, modem and router',
      'Carbonite data backup',
      'Support · 8 AM–8 PM EST',
    ],
  ),
  SupportPlan(
    id: 'advanced',
    name: 'Advanced SOS',
    description:
        "Covers 5 devices: laptops, desktops, printers, phones & routers.".tr,
    prices: {
      1: PlanPrice('2,325', '232.50'),
      2: PlanPrice('5,280', '528'),
      3: PlanPrice('7,672.50', '767.25'),
    },
    quarterlyTickets: 3,
    features: [
      'Endpoint security included',
      'Dedicated account manager',
      'Carbonite data backup',
      'Support · 8 AM–midnight EST',
    ],
  ),
];

final businessPlans = [
  SupportPlan(
    id: 'starter',
    name: 'Business Starter',
    description: "Essential internet security & backup for your business.".tr,
    prices: {1: PlanPrice('3,450', '345'), 2: PlanPrice('6,900', '690')},
    features: [
      'Office 365 included',
      '4 service calls · 1 per quarter',
      'Covers phones and tablets',
      'Chat support · 5-minute response target',
      'Support · 8 AM–8 PM EST',
    ],
  ),
  SupportPlan(
    id: 'professional',
    name: 'Business Professional',
    description: "Carbonite unlimited backup & Office for your team.".tr,
    prices: {1: PlanPrice('6,150', '615'), 2: PlanPrice('12,300', '1,230')},
    features: [
      'Office Pro Plus · 3 devices',
      '12 service calls · 3 per quarter',
      'Security for 5 devices',
      'Covers printer, modem and router',
      'Support · 8 AM–midnight EST',
    ],
  ),
  SupportPlan(
    id: 'enterprise',
    name: 'Business Enterprise',
    description: "Server protection & encrypted backup for your business.".tr,
    prices: {
      1: PlanPrice('16,665', '1,666.50'),
      2: PlanPrice('33,330', '3,333'),
    },
    features: [
      'Office Pro Plus & server backup',
      '20 service calls · 5 per quarter',
      'Endpoint security included',
      'Dedicated account manager',
      '24/7 on-demand assistance',
    ],
  ),
];
