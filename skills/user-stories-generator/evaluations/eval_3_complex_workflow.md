# Evaluation 3: Complex Multi-Step Workflow

## Input

**brief-structured.md**:
```markdown
## Workflow Utente
E-commerce checkout:
1. Add items to cart
2. Review cart
3. Enter shipping address
4. Choose payment method
5. Review order
6. Confirm purchase
7. Receive confirmation
```

## Expected Behavior

### Fase 3: Lista Titoli

Genera stories per workflow con relazioni:

```markdown
US-CART-001: Add product to cart
US-CART-002: View cart
US-CART-003: Update cart quantity
US-CART-004: Remove from cart

US-CHECKOUT-001: Enter shipping address
  REQUIRES: US-CART-002 (must have items)

US-CHECKOUT-002: Choose payment method
  REQUIRES: US-CHECKOUT-001

US-CHECKOUT-003: Review order before purchase
  REQUIRES: US-CHECKOUT-002

US-CHECKOUT-004: Confirm purchase
  REQUIRES: US-CHECKOUT-003

US-CHECKOUT-005: Receive order confirmation
  TRIGGERED_BY: US-CHECKOUT-004
```

### Fase 5: Espansione

Stories includono workflow step:

```markdown
### US-CHECKOUT-003: Review order before purchase

Come Customer, voglio rivedere ordine completo prima di acquistare
per verificare shipping, payment, items corretti.

#### Acceptance Criteria
- Quando arrivo a review step, allora vedo:
  - Items in cart con quantità e prezzi
  - Shipping address selezionato
  - Payment method selezionato
  - Total price (subtotal + shipping + tax)
- Quando clicco "Back", allora torno a payment method
- Quando clicco "Confirm", allora procedo a US-CHECKOUT-004

#### Workflow Position
Step 5 of 7 nel checkout flow

#### Relazioni
- REQUIRES: US-CHECKOUT-002 (payment method scelto)
- LEADS_TO: US-CHECKOUT-004 (confirm purchase)
```

## Expected Output

**user-stories-[project].md** include workflow diagram:

```markdown
## Checkout Workflow

```
US-CART-001 (Add to cart)
    │
    ▼
US-CART-002 (View cart)
    │
    ▼
US-CHECKOUT-001 (Shipping address)
    │
    ▼
US-CHECKOUT-002 (Payment method)
    │
    ▼
US-CHECKOUT-003 (Review order)
    │
    ▼
US-CHECKOUT-004 (Confirm purchase)
    │
    ▼
US-CHECKOUT-005 (Confirmation)
```

## Success Criteria
- ✅ Stories seguono workflow sequence
- ✅ REQUIRES relazioni tra stories
- ✅ Workflow position indicata
- ✅ Workflow diagram in output
- ✅ Back/forward navigation in AC

## Pass/Fail
**PASS**: Workflow sequence, relazioni, diagram
**FAIL**: Stories disordinate, no relazioni, workflow non chiaro
