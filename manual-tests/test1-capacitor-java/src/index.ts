import { registerPlugin } from '@capacitor/core';

import type { CapacitorJavaPlugin } from './definitions';

const CapacitorJava = registerPlugin<CapacitorJavaPlugin>('CapacitorJava', {
  web: () => import('./web').then((m) => new m.CapacitorJavaWeb()),
});

export * from './definitions';
export { CapacitorJava };
