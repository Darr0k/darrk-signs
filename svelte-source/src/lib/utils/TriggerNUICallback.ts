
export async function triggerNUICallback<T = any>(
    eventName: string,
    data: unknown = {},
    resource?: string
): Promise<T> {
    const options = {
        method: "post",
        headers: {
            "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify(data),
    };



    const resourceName = (window as any).GetParentResourceName
        ? (window as any).GetParentResourceName()
        : "nui-frame-app";


    const resp = await fetch(`https://${resource || resourceName}/${eventName}`, options);
    return await resp.json();
}