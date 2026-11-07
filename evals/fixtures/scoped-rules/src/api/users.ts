const cache = new Map<string, string>();

export function resetUsers(): void {
  cache.clear();
}

export function getUser(id: string): string | undefined {
  return cache.get(id);
}
