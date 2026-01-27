# Evaluation 2: MVP Prioritization

## Input

**brief-structured.md**:
```markdown
## Scope MVP
- User registration/login (MUST)
- Basic profile (MUST)
- Post creation (MUST)
- Comments (NICE TO HAVE)
- Likes (NICE TO HAVE)
- Notifications (NICE TO HAVE)
```

## Expected Behavior

### Fase 5: Espansione Stories

Classifica priorità correttamente:

```markdown
### US-AUTH-001: User registration
Priorità: **Must Have (P0)** - MVP critical

### US-PROFILE-001: View profile
Priorità: **Must Have (P0)** - MVP critical

### US-POST-001: Create post
Priorità: **Must Have (P0)** - MVP critical

### US-COMMENT-001: Add comment
Priorità: **Nice to Have (P2)** - Post-MVP

### US-LIKE-001: Like post
Priorità: **Nice to Have (P2)** - Post-MVP

### US-NOTIF-001: Receive notification
Priorità: **Nice to Have (P2)** - Post-MVP
```

## Expected Output

**user-stories-[project].md** con summary:

```markdown
# Summary

## By Priority
- Must Have (P0): 8 stories ← MVP CORE
- Should Have (P1): 5 stories ← MVP Nice-to-have
- Nice to Have (P2): 12 stories ← Post-MVP

## MVP Scope
Total MVP stories: 13 (Must + Should)
Post-MVP stories: 12

## Recommended Implementation Order
1. Phase 1 (Must Have): Auth + Profile + Post creation
2. Phase 2 (Should Have): Search + Filters
3. Phase 3 (Nice to Have): Comments + Likes + Notifications
```

## Success Criteria
- ✅ Priorità classificata (P0/P1/P2)
- ✅ MVP vs Post-MVP chiaro
- ✅ Must Have corrisponde a scope MVP brief
- ✅ Summary con count per priorità
- ✅ Implementation order suggerito

## Pass/Fail
**PASS**: Priorità accurate, MVP scope chiaro, implementation order
**FAIL**: Tutte Must Have, no differenziazione, scope MVP sbagliato
