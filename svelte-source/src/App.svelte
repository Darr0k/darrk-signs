<script>
    import { fly } from "svelte/transition";
	import { registerNUIMessage } from "./lib/utils";
	import { quintIn } from "svelte/easing";

	let show = false;
	let content = {
		type: "Paragraph",
		text: "Hi!",
	};

	registerNUIMessage("Show", (data) => {
        data.content.text = data.content.text.replace(/\n\n/g, "<br>")
        content = data.content;
        show = true;
    });

	registerNUIMessage("Hide", (data) => {
        show = false;
    });
</script>

<!-- svelte-ignore empty-block -->
{#if show}
	<div class="content" transition:fly={{x: 200, easing: quintIn}}>
		{#if content?.type == "Image"}
            <img src="{content.text}" alt="">
        {:else}
			<p>{@html content?.text}</p>
		{/if}

		<div class="important">*This content is by a player and the server is not responsible</div>
	</div>
{/if}