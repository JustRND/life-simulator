# Economy update

## Where to find the systems

- Activities → Finance Market, directly below Careers & Jobs.
- Activities → Learning & Smarts.
- Options → Settings → Language / Currency.

## Market model

There are 24 company archetypes and exactly eight active exchange listings, including player IPOs. New issuers receive fresh names from the company-name dataset and NPC owners from the country-aware name catalog. Retired issuers never reuse an old share ID.

Prices advance once per character year. Sixteen simulated investors trade from cash budgets and actual share inventories. Net demand, company performance, and an economy-wide shock determine returns. Refreshing a panel does not advance prices. The maximum annual change is ±45%; prices have a positive floor. This is a fictional simplified market with an exchange liquidity provider, not a real order book.

Each company has 100,000 total shares and a 20,000-share public float. Trading uses pocket cash and charges 1% (minimum $1). Buy orders are rounded up, sell proceeds down. Short selling and borrowing to trade are not supported. A portfolio chart compares share value with net cash invested and retains up to 80 yearly samples. It does not include the value of privately owned businesses.

Eligible NPC companies have an 8% annual closure chance after two years. Bankruptcy pays zero; other delistings pay 80% of the final quote. Holdings settle automatically and replacement issuers keep the board at eight listings. NPC buyers and sellers also trade player IPOs, affecting valuation and therefore business borrowing capacity. Ordinary secondary trades do not deposit money into the company's treasury.

## Acquisitions, IPOs, resale and inheritance

Adults outside prison can acquire NPC businesses without a license or degree. Acquisitions use cash, then savings, and cost 125% of quoted market capitalization, less the value of shares already owned. The purchased company appears among owned business assets and uses the existing management system.

IPO eligibility requires **more than $1,000,000 cumulative after-tax net profit**, no unpaid business taxes, and a nonnegative treasury. Historical profit was not recorded in older saves, so existing companies accumulate qualifying profit from this update onward. An IPO sells 20% through an underwriter, retains 80% owner control, and deposits proceeds minus a 5% fee in the business treasury. A company can IPO only once. Listing requires an NPC slot with no player-held shares to displace; otherwise the player must sell a holding first.

Dividends and resale proceeds respect the player's ownership fraction. Corporate debts and unpaid taxes reduce resale proceeds; uncovered liabilities become personal debt rather than disappearing. Shares and businesses persist in normal saves and named life slots. Child succession transfers businesses and stock holdings intact, rebases the market's age clock, and does not also grant their value as cash.

## Balance

- Six learning activities: reading, logic puzzles, chess, museums, language courses, and workshops. Reading and puzzles are free. Each is limited to once a year; any completed activity protects against the following annual smarts decline. Gains taper above 85 smarts.
- Each parent's own positive interactions, partner interactions, and child time/gifts protect that relationship for the year just completed. Untended annual decay: parents 2–3, partner 2–4, children 1–2.
- Generic event stat changes are bounded to −12/+10, preserving explicitly lethal health outcomes. Cash changes are bounded by age: $150 below 13, $1,000 below 18, and $12,000 for adults. Choice summaries show the actual adjusted values.
- Retail, food-service, and youth base salaries and promotion salaries increase 12%. Criminal salaries reduce 20%. Other salaries above $150,000 reduce 8%. Existing careers migrate once to the matching balanced salary.
- Scratchcards: 18% win probability, expected gross payout $23.76 on a $25 stake. Slots: 4% triple-match probability, expected gross payout $46 on a $50 stake. Existing yearly play limits remain; dice retain their existing house edge.

## Languages and currencies

The first localization pass covers market and learning panels, options/settings, and common navigation in English, Indonesian and Russian. Existing long-form stories and some older specialized panels retain their English fallback. Translations live in `data/localization/ui.json`.

Game balances remain in base USD. Currency selection changes display values at fixed fictional rates: USD 1, IDR 16,000, EUR 0.92, GBP 0.79, JPY 150 per base dollar. These are game constants, not live exchange rates. Real-money shop previews retain their original denomination. Preferences persist locally.

## Verification

`tests/economy_market_test.tscn` checks trades and fees, invalid orders, 40 years of turnover, share conservation, NPC budgets, acquisition credit, IPO threshold and duplication guards, saving/loading, inheritance, insolvency, learning cooldowns, and currency preferences.

`tests/finance_ui_test.tscn` checks button placement, per-relative annual maintenance, displayed event modifiers, and renders the exchange, portfolio graph, learning panel and settings in multiple languages. Both tests use isolated files for writes and do not overwrite the normal player save.
