import { WebPlugin } from '@capacitor/core';

import type { CapacitorKotlinPlugin } from './definitions';

export class CapacitorKotlinWeb extends WebPlugin implements CapacitorKotlinPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
