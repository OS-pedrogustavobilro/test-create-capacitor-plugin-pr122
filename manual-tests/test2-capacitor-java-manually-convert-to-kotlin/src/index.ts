import { registerPlugin } from '@capacitor/core';

import type { CapacitorJavaToKotlinPlugin } from './definitions';

const CapacitorJavaToKotlin = registerPlugin<CapacitorJavaToKotlinPlugin>('CapacitorJavaToKotlin', {
  web: () => import('./web').then((m) => new m.CapacitorJavaToKotlinWeb()),
});

export * from './definitions';
export { CapacitorJavaToKotlin };
