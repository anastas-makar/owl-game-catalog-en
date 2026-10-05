# Medals

Each file describes one medal template.

After successfully completing an expedition and liberating a map, the animal that took part in the expedition receives the medal associated with that map.

A map can be liberated only once. In the current model, each map may be associated with one medal for its liberation.

A medal is not ordinary loot: it is not listed in `lootBundle` and does not use `allowedAcquisitionSources`. The liberation medal is specified directly in the map description.

General guidelines are in [`catalog/README.md`](../README.md).

## Example

```json
{
  "templateId": "swamp-liberator",
  "title": "Swamp Liberation Medal",
  "description": "Awarded for liberating the swamp from monsters.",
  "sourceImageUrl": "https://example.org/swamp-liberator.png"
}
```

The published catalog uses `imageKey` instead of `sourceImageUrl`. For details, see the general image guidelines in [`catalog/README.md`](../README.md).

## Relationship to a map

A map specifies the medal granted after its liberation through `completionMedalTemplateId`:

```json
{
  "completionMedalTemplateId": "swamp-liberator"
}
```

`completionMedalTemplateId` must match the `templateId` of an existing medal.

For example, the map:

```json
{
  "templateId": "swamp-map",
  "completionMedalTemplateId": "swamp-liberator"
}
```

grants the following medal after liberation:

```text
swamp-liberator
```

For details on map liberation and expedition rewards, see the [map documentation](../maps/README.md).

## `templateId`

A medal's `templateId` must be unique among medals.

After publication, `templateId` is considered stable. Changing it requires updating all maps that reference this medal and, once user data exists, may also require accounting for medals already granted.

## Validation

Before opening a pull request, check:

* the medal's `templateId` is unique among medals;
* `title` clearly describes the medal;
* `description` matches the condition for receiving it;
* the map for which the medal is intended references the correct `templateId`;
* the image is provided through `sourceImageUrl` or `imageKey`, rather than added to the repository as a binary file.
