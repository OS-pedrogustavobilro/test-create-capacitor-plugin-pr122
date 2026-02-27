import { registerPlugin } from '@capacitor/core';

import type { CapacitorKotlinPlugin } from './definitions';

const CapacitorKotlin = registerPlugin<CapacitorKotlinPlugin>('CapacitorKotlin', {
  web: () => import('./web').then((m) => new m.CapacitorKotlinWeb()),
});

export * from './definitions';
export { CapacitorKotlin };
