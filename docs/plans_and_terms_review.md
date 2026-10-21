# Plans and terms implementation notes

The catalog is transcribed from the three screenshots supplied on September 30, 2026. Prices retain the supplied dollar symbol, annual billing labels, and separate monthly amounts. Monthly prices are not calculated as annual prices divided by twelve. Confirm the currency and billing meaning before enabling purchases.

The third screenshot has residential “3 Years” selected but business “2 Years” selected. No three-year business prices were provided; those cards explicitly show unavailable pricing. Business service-call allowances remain as displayed, rather than multiplying their totals for longer terms. Confirm whether they are annual allowances. Residential ticket totals scale as shown in the references.

The Plans tab is index 4, preserving the existing Home, Services, Bookings and Profile indices. Its white pulse runs only while unselected, with reduced-motion and app lifecycle support. Existing destinations do not blink.

Plans now load from GET /api/plans. Prices, currencies, terms and features come from the backend; each purchase is a single payment for the full term, not recurring billing. POST /api/plans/purchases sends only planId. Stripe PaymentSheet collects card details; the app retrieves the PaymentIntent and calls POST /api/plans/purchases/verify. Only a verified active response grants access. GET /api/plans/my-purchases refreshes shared plan/profile history. Pending purchase and intent IDs are stored by customer ID for verification retry, without card data or client secrets. The history parser accepts data.planPurchases or data.purchases; the supplied guide did not specify this list envelope.

Terms & Conditions is a draft aligned with the current privacy policy and supplied plan descriptions. Before publication, verify the legal entity and contact, effective date, jurisdiction, booking cancellation/refund rules, subscription renewal and cancellation procedures, onboarding fee treatment, third-party licences, and service commitments. No arbitrary liability cap, arbitration clause, refund deadline, or auto-renewal contract has been invented.

Reference for clear disclosure of subscription terms before payment: https://www.ftc.gov/news-events/press-releases/2024/06/ftc-takes-action-against-adobe-executives-hiding-fees-preventing-consumers-easily-cancelling
