// KeyPressListener.ts
import { onMount, onDestroy } from 'svelte';

export function keyPressListener(targetKey: string) {
    let keyPressed = false;

    onMount(() => {

        const downHandler = ({ key }: KeyboardEvent) => {
            if (key === targetKey) {
                keyPressed = true;
            }
        };

        const upHandler = ({ key }: KeyboardEvent) => {
            if (key === targetKey) {
                keyPressed = false;
            }
        };

        const onKeyDown = (event: KeyboardEvent) => downHandler(event);
        const onKeyUp = (event: KeyboardEvent) => upHandler(event);
        window.addEventListener('keydown', onKeyDown);
        window.addEventListener('keyup', onKeyUp);
    });

    onDestroy(() => {

        const downHandler = ({ key }: KeyboardEvent) => {
            if (key === targetKey) {
                keyPressed = true;
            }
        };

        const upHandler = ({ key }: KeyboardEvent) => {
            if (key === targetKey) {
                keyPressed = false;
            }
        };
        const onKeyDown = (event: KeyboardEvent) => downHandler(event);
        const onKeyUp = (event: KeyboardEvent) => upHandler(event);
        window.removeEventListener('keydown', onKeyDown);
        window.removeEventListener('keyup', onKeyUp);
    });
    return keyPressed;
}
