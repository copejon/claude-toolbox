# Transaction Categorization Rules

## Auto-Categorize by Payee (Always Same Category)

### Inflows
| Payee | Category |
|-------|----------|
| Red Hat Inc Payroll | Inflow: Ready to Assign |
| US Department of Veterans Affairs | Inflow: Ready to Assign |
| Interest Paid | Inflow: Ready to Assign |
| Mobile Deposit | Inflow: Ready to Assign |
| PennyMac (inflow) | Rental Property Mortgage |
| Properties Sigonfile | Rental Property Mortgage |

### Bills & Subscriptions
| Payee | Category |
|-------|----------|
| Windrose Realty Web / Apf Windrose Realty | Rent |
| PennyMac (outflow) | Rental Property Mortgage |
| Lakeview Loan Servicing | Mortgage |
| Clckpay Kallison Ranch | HOA |
| USAA P&C Insurance | Auto and Property Insurance |
| Verizon Wireless | Cellular Broadband |
| AT&T | Internet |
| Google Fiber | Internet |
| CPS Energy / City Public Service | Utilities (starting Jan 2026) |
| SAWS / San Antonio Water | Utilities (starting Jan 2026) |
| Tiger Sanitation | Utilities |
| Frontier Waste | Utilities |
| Appliance Warehouse | Appliance Rental |
| Disney+ | Entertainment Subscription |
| Netflix | Entertainment Subscription |
| Audible | Entertainment Subscription |
| Spotify | Entertainment Subscription |
| YouTube Music | Entertainment Subscription |
| NY Times / Google NYTimes / PayPal NYT | Entertainment Subscription |
| PayPal `***TIME` ($4.26) | Entertainment Subscription |
| Todoist | Non-Entertainment Subscription |
| 1Password | Non-Entertainment Subscription |
| Paypal Truthfinder (`***NDER`) | Non-Entertainment Subscription |
| Paypal Spokeo (`*** INC`) | Non-Entertainment Subscription |
| Sam's Club | Non-Entertainment Subscription |

### Groceries & Gas
| Payee | Category |
|-------|----------|
| H-E-B | Groceries |
| Instacart | Groceries |
| Specs via Instacart | Groceries |
| Liquer III Culebr/Culebra | Groceries |
| Walmart | Groceries |
| Mary Jane's CBD / Mary Janes CBD | Supplements |
| Cash App (to Aluradanin) | Supplements |
| Murphy | Gas |
| RaceWay | Gas |

### Gas Stations (Amount-Based)
| Payee | Condition | Category |
|-------|-----------|----------|
| Circle K, Refuel, Shell, Select Stop | > $35 | Gas |
| Circle K, Refuel, Shell, Select Stop | < $20 | Groceries |
| Circle K, Refuel, Shell, Select Stop | $20 - $35 | **Manual input** |

### Restaurants & Food
| Payee | Category |
|-------|----------|
| Burger King | Restaurants |
| Chick-Fil-A | Restaurants |
| McDonald's | Restaurants |
| Wendy's | Restaurants |
| Sonic Drive-In | Restaurants |
| Slim Chickens | Restaurants |
| Tacos Express | Restaurants |
| Jersey Mike's | Restaurants |
| Yummy Kitchen | Restaurants |
| Marco's Pizza | Delivery & Take-out |
| Domino's | Delivery & Take-out |
| DoorDash | **Split**: food → Restaurants, fee → Delivery Service Fees and Tips (ask user for breakdown) |
| Uber Eats | **Split**: food → Restaurants, fee → Delivery Service Fees and Tips (ask user for breakdown) |
| Favor | **Split**: food → Restaurants, fee → Delivery Service Fees and Tips (ask user for breakdown) |

### Coffee & Bars
| Payee | Category |
|-------|----------|
| Summer Moon Coffee | Coffee Shops |
| Flower in Flour | Coffee Shops |
| Stout House / Stout House Kallison | Bars |
| St. Elmo Brewing | Bars |
| Toasty Badger | Bars |

### Refuge Coffee Beer (Amount-Based)
| Condition | Category |
|-----------|----------|
| < $7 | Coffee Shops |
| >= $7 | Bars |

### Headway (Amount-Based)
| Condition | Category |
|-----------|----------|
| exactly $20 | **Manual input** (depends on provider) |
| >= $75 | Punitive Service Charges |

### Health & Medical
| Payee | Category |
|-------|----------|
| Almouie / Almouie Pediatrics | Medical Copays |
| Patientpmt.com | Medical Copays |
| Med*Fast | Mental Health Copays |
| Texas MedClinic | Medical Co-Pays |
| Institute of Orthopaedi | Medical Co-Pays |
| Mercy Wellness LLC | Medical Co-Pays |
| Staats Psychiatric | Medical Co-Pays |
| Sohdental | Medical Co-Pays |
| CVS Pharmacy | Groceries |

### Home
| Payee | Category |
|-------|----------|
| Lowe's | Maintenance |
| AutoZone | Auto Maintenance |
| New Burnin' Bush | Yard & Garden |

### Kids & Family
| Payee | Category |
|-------|----------|
| Five Below | Kids' Purchases |
| Dragon's Lair | Kids' Purchases |
| Google Roblox | Kids' Purchases |
| Microsoft Store | Kids' Purchases |
| Urban Air / Jfi Urban Air | Family Activities |
| Menchie's Frozen Yogurt | Family Activities |
| Jojo Kettlecorn | Family Activities |
| Sip & Sno | Family Activities |
| Prime Video | Family Activities |

### Personal
| Payee | Category |
|-------|----------|
| Sport Clips | Grooming |
| Steam | Games |
| San Antonio SSC | Social Clubs |

### Transfers & Payments
| Payee | Category |
|-------|----------|
| Chase Credit Card (outflow) | **Manual input** (depends on card payee) |
| Zelle Transfer from Mary Cope | Mortgage |
| OurFamilyWizard ($1,800 outflow) | Child Support |
| OurFamilyWizard ($2,000 outflow) | Temporary Housing Support |
| OurFamilyWizard (smaller outflows) | Kids Medical |
| OurFamilyWizard (small inflows) | Mental Health Copays (reimbursements from Jessica) |

## Always Manual Input (Ad Hoc)
- Amazon
- Target
- Barnes & Noble
- Marshalls
- Roblox (Gifts vs Kids' Purchases)
- PlayStation (kids vs personal)
- Minecraft (kids vs personal)
- Venmo
- Chase Credit Card outflows
