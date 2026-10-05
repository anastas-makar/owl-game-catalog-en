# Pouches

Each JSON file describes one decorative pouch template. Pouches are used only as images in the reward selection animation.

A pouch template is not a game world object. Since all pouches participate in an animation on one screen, too many are unnecessary. There are currently no plans to increase the number of pouches.

## Format

```json
{
  "templateId": "pouch1",
  "imageKey": "pouches/pouch1.png",
  "tags": [
  "default"
  ]
}
```

The filename must match `templateId`: the `pouch1` template is stored in `pouch1.json`.

`imageKey` is an S3 object key without a leading `/`. The standard set uses keys `pouches/pouch1.png` … `pouches/pouch32.png`.

## Tags

The `tags` field is required, must be nonempty, and must contain no empty or duplicate values.

The current ordinary set has the tag:

```text
default
```

In the future, individual designs may use, for example, `new_year`, `halloween`, or `spring`. The game will display the set with a particular tag; `default` is used by default.

## Validation

There are currently no plans to increase the number of pouches, to avoid overloading the animation.

Before opening a pull request, check:

* `templateId` is unique among pouches;
* the JSON filename matches `templateId`;
* the image is specified through `imageKey` or a `sourceImageUrl` allowed for the working branch;
* `imageKey` does not start with `/`;
* at least one nonempty tag is present;
* the same tag does not repeat within the template.

