import { onDestroy, onMount } from 'svelte';

type FrameVisibleSetter = (bool: boolean) => void;

const LISTENED_KEYS = ["Escape"];

export function useExitListener(visibleSetter: FrameVisibleSetter) {
    let setterRef: FrameVisibleSetter;

    onMount(() => {
        setterRef = visibleSetter;

        const keyHandler = (e: KeyboardEvent) => {
            if (LISTENED_KEYS.includes(e.code)) {
                setterRef(false);
            }
        };

        window.addEventListener('keyup', keyHandler);

        onDestroy(() => {
            window.removeEventListener('keyup', keyHandler);
        });
    });
}