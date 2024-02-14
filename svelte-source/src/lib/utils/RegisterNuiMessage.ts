export const isEnvBrowser = (): boolean => !(window as any).invokeNative;

interface NuiMessageData<T = unknown> {
    type: string;
    payload: T;
}

type NuiHandlerSignature<T> = (data: T) => void;

export function registerNUIMessage<T>(type: string, handler: NuiHandlerSignature<T>) {
    window.addEventListener('message', (event) => {
        if (type == event.data.action) {
            handler(event.data)
        }
    });
    // const eventListener = (event: MessageEvent<NuiMessageData<T>>) => {
    //     const { type: eventType, payload } = event.data;

    //     // Debugging line
    //     console.log(eventType, type, payload, event.data);

    //     if (eventType === type) {
    //         handler(payload);
    //     }
    // };

    // if (!isEnvBrowser()) {
    //     window.addEventListener('message', eventListener);

    //     return () => {
    //         window.removeEventListener('message', eventListener);
    //     };
    // }
}
