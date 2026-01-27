# State Management Comparison

## Quick Decision Matrix

| Criterio | Zustand | Redux Toolkit | React Query | Riverpod | BLoC |
|----------|---------|---------------|-------------|----------|------|
| **Learning Curve** | Low | Medium | Low | Medium | High |
| **Boilerplate** | Minimal | Medium | Minimal | Low | High |
| **TypeScript** | Excellent | Excellent | Excellent | Excellent | Excellent |
| **DevTools** | Yes | Yes | Yes | Yes | Yes |
| **Server State** | No | RTK Query | Yes | Yes | No |
| **Bundle Size** | ~1KB | ~12KB | ~12KB | ~1KB | ~1KB |
| **Best For** | Client state | Complex state | Server state | Flutter | Flutter |

---

## When to Use What

### Zustand (React)

**Use when**:
- Simple to medium complexity apps
- You want minimal boilerplate
- Client-side state (theme, UI, auth)
- TypeScript-first development

**Don't use when**:
- You need time-travel debugging extensively
- Team prefers Redux patterns

```typescript
import { create } from 'zustand';

interface CounterState {
  count: number;
  increment: () => void;
  decrement: () => void;
}

export const useCounterStore = create<CounterState>((set) => ({
  count: 0,
  increment: () => set((state) => ({ count: state.count + 1 })),
  decrement: () => set((state) => ({ count: state.count - 1 })),
}));
```

### Redux Toolkit (React)

**Use when**:
- Large applications with complex state
- Team familiar with Redux
- Need time-travel debugging
- Complex async flows with middleware

**Don't use when**:
- Simple apps (overkill)
- Small team unfamiliar with Redux

```typescript
import { createSlice, configureStore } from '@reduxjs/toolkit';

const counterSlice = createSlice({
  name: 'counter',
  initialState: { value: 0 },
  reducers: {
    increment: (state) => { state.value += 1; },
    decrement: (state) => { state.value -= 1; },
  },
});
```

### React Query / TanStack Query (React)

**Use when**:
- Fetching server data
- Need caching, refetching, sync
- Real-time data updates
- Pagination, infinite scroll

**Don't use when**:
- Pure client-side state
- No server interaction

```typescript
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';

function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => api.getUsers(),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}

function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: api.createUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

### Riverpod (Flutter)

**Use when**:
- Flutter applications
- Type-safe dependency injection
- Compile-time safety
- Testing with overrides

**Don't use when**:
- You prefer BLoC patterns
- Team unfamiliar with providers

```dart
// Provider definition
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
  void decrement() => state--;
}

// Usage
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

### BLoC (Flutter)

**Use when**:
- Large Flutter applications
- Team familiar with reactive patterns
- Need strict separation of concerns
- Enterprise applications

**Don't use when**:
- Small apps (overkill)
- Team unfamiliar with streams

```dart
// Event
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}

// State
class CounterState {
  final int count;
  CounterState(this.count);
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<Increment>((event, emit) => emit(CounterState(state.count + 1)));
    on<Decrement>((event, emit) => emit(CounterState(state.count - 1)));
  }
}
```

---

## Recommended Combinations

### React Web App (Typical)
```
Client State:  Zustand
Server State:  React Query
Form State:    React Hook Form
URL State:     Next.js/React Router
```

### React Enterprise App
```
All State:     Redux Toolkit + RTK Query
Form State:    React Hook Form
URL State:     React Router
```

### Flutter Mobile App
```
All State:     Riverpod
Local Storage: SharedPreferences / Hive
API Caching:   Dio + Cache Interceptor
```

### Flutter Enterprise App
```
Business Logic: BLoC
Dependencies:   GetIt + Injectable
Local Storage:  Hive
```

---

## State Categories Recap

| Category | What | Solution |
|----------|------|----------|
| **Server State** | Data from API | React Query, RTK Query, Riverpod |
| **Client State** | UI state, theme | Zustand, Redux, Riverpod |
| **Form State** | Form inputs | React Hook Form, Formik |
| **URL State** | Route params | Router (built-in) |
| **Local State** | Component-specific | useState, useReducer |
