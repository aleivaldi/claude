# JSON Format Reference - Business Plan

Questo documento specifica il formato JSON completo per `bp_data.json` utilizzato dallo script `populate_excel.py`.

---

## Struttura Completa

```json
{
  "metadata": {
    "project_name": "Nome Progetto",
    "company": "Nome Azienda",
    "author": "Nome Autore",
    "date": "2025-11-20",
    "version": "v1.0",
    "currency": "EUR",
    "start_date": "2026-01-01",
    "projection_months": 36
  },

  "macro": {
    "annual_inflation_rate": 0.02
  },

  "revenues": {
    "amazon": {
      "price": 150.0,
      "quantities": [0, 0, 0, 100, 150, 200],
      "growth_rate": 0.1
    },
    "distribution": {
      "price": 120.0,
      "quantities": [0, 0, 50, 75, 100, 125],
      "growth_rate": 0.08
    }
  },

  "cogs": {
    "product_cogs_per_unit": 50.0,
    "amazon_referral_fee_pct": 0.15,
    "packaging_per_unit": 5.0,
    "shipping": {
      "factory_to_warehouse": 3.0,
      "warehouse_to_distributor": 2.0,
      "warehouse_to_amazon": 4.0
    }
  },

  "marketing": {
    "ltv_cac_ratio": 3.0,
    "budget_override": null
  },

  "personnel": {
    "salaries": {
      "c_level": 5000,
      "finance": 5000,
      "sales": 5000,
      "marketing": 3700,
      "product": 3500,
      "operations": 3500
    },
    "ftes": {
      "c_level": [1, 1, 1, 1, 1, 1],
      "finance": [0, 0, 0, 1, 1, 1],
      "sales": [0, 0, 1, 1, 1, 2],
      "marketing": [0, 1, 1, 1, 1, 1],
      "product": [1, 1, 1, 2, 2, 2],
      "operations": [1, 1, 1, 1, 1, 2]
    },
    "pension_provision_rate": 0.0691,
    "capitalization_rate": 0.5
  },

  "gna": {
    "warehouse_rent": 1000,
    "saas_per_employee": 200,
    "cpa_monthly": 1000,
    "hr_consultant_per_employee": 30,
    "other_pct": 0.15
  },

  "taxes": {
    "ires": 0.24,
    "irap": 0.039,
    "vat": 0.22
  },

  "financing": {
    "equity_injections": [
      {"month": 1, "amount": 140000},
      {"month": 12, "amount": 250000}
    ],
    "debt": {
      "initial_amount": 0,
      "interest_rate_annual": 0.10
    }
  },

  "capex": {
    "intangible": {
      "initial_tech_product": 140000,
      "ongoing_monthly": 0,
      "amortization_rate_annual": 0.20
    },
    "tangible": {
      "capex_per_employee": 1000,
      "depreciation_rate_annual": 0.3333
    }
  }
}
```

---

## Regole Formato

### Generali
- **Tutti gli importi**: Unità base (EUR, USD, etc.) senza separatori
- **Percentuali**: Formato decimale (15% = 0.15)
- **Date**: Formato ISO 8601 `YYYY-MM-DD`
- **Campi opzionali**: Possono essere `null` o omessi

### Arrays Temporali
Arrays come `quantities` o `ftes` rappresentano valori per periodo:

```json
"quantities": [0, 0, 100, 150, 200]
```

**Comportamento**:
- Se array più corto di `projection_months`: Ultimo valore viene ripetuto
- Se valore singolo fornito: Applicato a tutti i periodi
- Esempio: `"quantities": 100` → `[100, 100, 100, ...]` per tutti i mesi

---

## Sezioni Dettagliate

### metadata
| Campo | Tipo | Required | Note |
|-------|------|----------|------|
| `project_name` | string | ✅ | Nome progetto/prodotto |
| `company` | string | ✅ | Ragione sociale |
| `author` | string | ✅ | Chi prepara BP |
| `date` | string | ✅ | Data preparazione (ISO 8601) |
| `version` | string | ✅ | Versioning BP (es. "v1.0") |
| `currency` | string | ✅ | Codice valuta ISO 4217 (EUR, USD, GBP) |
| `start_date` | string | ✅ | Prima data fiscale (ISO 8601) |
| `projection_months` | integer | ✅ | Durata proiezione (12-60) |

### macro
| Campo | Tipo | Default | Range |
|-------|------|---------|-------|
| `annual_inflation_rate` | decimal | 0.02 | 0.0-0.10 |

### revenues.amazon
| Campo | Tipo | Required | Note |
|-------|------|----------|------|
| `price` | decimal | ✅ | Prezzo vendita (IVA esclusa) |
| `quantities` | array\[int\] | ✅ | Unità per periodo |
| `growth_rate` | decimal | ❌ | Crescita mensile (0.10 = 10%) |

### revenues.distribution
Stessa struttura di `amazon`.

### cogs
| Campo | Tipo | Required | Note |
|-------|------|----------|------|
| `product_cogs_per_unit` | decimal | ✅ | Costo produzione unitario |
| `amazon_referral_fee_pct` | decimal | ✅ | Fee Amazon (0.15 = 15%) |
| `packaging_per_unit` | decimal | ✅ | Costo packaging |
| `shipping` | object | ✅ | Costi shipping (vedi sotto) |

### cogs.shipping
| Campo | Tipo | Required | Note |
|-------|------|----------|------|
| `factory_to_warehouse` | decimal | ✅ | Costo per unità |
| `warehouse_to_distributor` | decimal | ✅ | Costo per unità |
| `warehouse_to_amazon` | decimal | ✅ | Costo per unità |

### marketing
| Campo | Tipo | Required | Note |
|-------|------|----------|------|
| `ltv_cac_ratio` | decimal | ✅ | Target ratio (3.0-5.0 healthy) |
| `budget_override` | decimal | ❌ | Se specificato, bypassa LTV/CAC calc |

### personnel.salaries
Tutti i campi `decimal` per salario lordo mensile:
- `c_level`
- `finance`
- `sales`
- `marketing`
- `product`
- `operations`

### personnel.ftes
Tutti i campi `array[decimal]` per FTE per periodo:
- `c_level` - Array FTE per periodo
- `finance` - Array FTE per periodo
- etc.

**Esempio**:
```json
"ftes": {
  "c_level": [1, 1, 1, 1],  // 1 FTE costante
  "product": [1, 1, 2, 2]   // Hiring in mese 3
}
```

### personnel (altri campi)
| Campo | Tipo | Default | Note |
|-------|------|---------|------|
| `pension_provision_rate` | decimal | 0.0691 | TFR Italia 6.91% |
| `capitalization_rate` | decimal | 0.0-0.8 | % R&D capitalizzabile |

### gna
| Campo | Tipo | Required | Note |
|-------|------|----------|------|
| `warehouse_rent` | decimal | ✅ | Affitto mensile |
| `saas_per_employee` | decimal | ✅ | Tool per persona/mese |
| `cpa_monthly` | decimal | ✅ | Commercialista mensile |
| `hr_consultant_per_employee` | decimal | ✅ | HR services per persona/mese |
| `other_pct` | decimal | ✅ | % buffer imprevisti (0.15 = 15%) |

### taxes
| Campo | Tipo | Default | Note |
|-------|------|---------|------|
| `ires` | decimal | 0.24 | Corporate income tax (Italia 24%) |
| `irap` | decimal | 0.039 | Regional tax (Italia 3.9%) |
| `vat` | decimal | 0.22 | IVA (Italia 22%) |

### financing.equity_injections
Array di oggetti:
```json
[
  {"month": 1, "amount": 140000},
  {"month": 12, "amount": 500000}
]
```

| Campo | Tipo | Note |
|-------|------|------|
| `month` | integer | Mese injection (1-based) |
| `amount` | decimal | Ammontare equity |

### financing.debt
| Campo | Tipo | Note |
|-------|------|------|
| `initial_amount` | decimal | Debito iniziale |
| `interest_rate_annual` | decimal | Tasso annuo (0.10 = 10%) |

### capex.intangible
| Campo | Tipo | Note |
|-------|------|------|
| `initial_tech_product` | decimal | Capex iniziale R&D/software |
| `ongoing_monthly` | decimal | Capex ricorrente mensile |
| `amortization_rate_annual` | decimal | Tasso ammortamento annuo (0.20 = 5 anni) |

### capex.tangible
| Campo | Tipo | Note |
|-------|------|------|
| `capex_per_employee` | decimal | Capex per nuovo FTE (laptop, desk) |
| `depreciation_rate_annual` | decimal | Tasso depreciation annuo (0.3333 = 3 anni) |

---

## Validazione JSON

Prima di usare il JSON, validare:

```bash
python3 -m json.tool /tmp/bp_data.json
```

Se valido, output sarà JSON formattato. Se invalido, mostra errore syntax.

---

## Esempi Completi

### Esempio Minimo (Required Fields Only)
```json
{
  "metadata": {
    "project_name": "Minimal Project",
    "company": "Test SRL",
    "author": "Team",
    "date": "2025-11-20",
    "version": "v1.0",
    "currency": "EUR",
    "start_date": "2026-01-01",
    "projection_months": 12
  },
  "macro": {"annual_inflation_rate": 0.02},
  "revenues": {
    "amazon": {"price": 150, "quantities": [100]},
    "distribution": {"price": 120, "quantities": [50]}
  },
  "cogs": {
    "product_cogs_per_unit": 50,
    "amazon_referral_fee_pct": 0.15,
    "packaging_per_unit": 5,
    "shipping": {
      "factory_to_warehouse": 3,
      "warehouse_to_distributor": 2,
      "warehouse_to_amazon": 4
    }
  },
  "marketing": {"ltv_cac_ratio": 3.0},
  "personnel": {
    "salaries": {"c_level": 5000, "finance": 5000, "sales": 5000, "marketing": 3700, "product": 3500, "operations": 3500},
    "ftes": {"c_level": [1], "finance": [0], "sales": [0], "marketing": [0], "product": [1], "operations": [1]},
    "pension_provision_rate": 0.0691,
    "capitalization_rate": 0.5
  },
  "gna": {
    "warehouse_rent": 1000,
    "saas_per_employee": 200,
    "cpa_monthly": 1000,
    "hr_consultant_per_employee": 30,
    "other_pct": 0.15
  },
  "taxes": {"ires": 0.24, "irap": 0.039, "vat": 0.22},
  "financing": {
    "equity_injections": [{"month": 1, "amount": 140000}],
    "debt": {"initial_amount": 0, "interest_rate_annual": 0.10}
  },
  "capex": {
    "intangible": {"initial_tech_product": 140000, "ongoing_monthly": 0, "amortization_rate_annual": 0.20},
    "tangible": {"capex_per_employee": 1000, "depreciation_rate_annual": 0.3333}
  }
}
```

### Esempio con Growth e Hiring Plan
```json
{
  "revenues": {
    "amazon": {
      "price": 150,
      "quantities": [0, 0, 100, 150, 200, 250, 300],
      "growth_rate": 0.15
    }
  },
  "personnel": {
    "ftes": {
      "c_level": [1, 1, 1, 1, 1, 1, 1],
      "product": [1, 1, 2, 2, 3, 3, 4],
      "sales": [0, 0, 1, 1, 2, 2, 3]
    }
  }
}
```

---

## Errori Comuni

### Error: "Field X not found"
**Causa**: Campo required mancante nel JSON

**Fix**: Aggiungi campo con valore appropriato

### Error: "Invalid date format"
**Causa**: Date non in formato ISO 8601

**Fix**: Usa `YYYY-MM-DD` (es. "2026-01-01")

### Error: "Array length mismatch"
**Causa**: Array ha valori ma nessuno corrisponde ai mesi

**Fix**: Array può essere più corto (ultimo valore ripetuto) ma non più lungo di `projection_months`

### Warning: "Percentage > 1.0"
**Causa**: Percentuale specificata come 15 invece di 0.15

**Fix**: Converti percentuali in decimale (15% = 0.15)
