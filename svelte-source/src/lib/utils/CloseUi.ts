import { triggerNUICallback } from "."

export function closeUi(closeFunction: Function) {
    closeFunction();
    triggerNUICallback("closeUi", {});
}