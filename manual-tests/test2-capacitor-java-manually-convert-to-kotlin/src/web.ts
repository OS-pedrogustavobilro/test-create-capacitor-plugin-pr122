import { WebPlugin } from '@capacitor/core';

import type { CapacitorJavaToKotlinPlugin } from './definitions';

export class CapacitorJavaToKotlinWeb extends WebPlugin implements CapacitorJavaToKotlinPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
