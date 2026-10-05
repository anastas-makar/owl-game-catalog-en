# Animals

An animal is a character in the game world.

An animal lives in a house or castle, can cook, take part in expeditions, and serve as a city mayor or country ruler.

Animals are never granted through a pouch, the shop, or `lootBundle`.

If a city has an unoccupied house or castle, animals looking for a home start appearing in the game.

The player can choose to move an animal into an unoccupied house or castle or send it away.

The player names the animal when it moves in.

General catalog guidelines are in [`catalog/README.md`](../README.md).

## Example

```json
{
  "templateId": "lonely-dog",
  "initialDisplayName": "Lonely Dog",
  "kind": "Dog",
  "sourceImageUrl": "https://example.org/lonely-dog.png"
}
```

The published catalog uses `imageKey` instead of `sourceImageUrl`. For details, see the general image guidelines in [`catalog/README.md`](../README.md).

## `templateId`

`templateId` is the stable identifier of an animal template.

For example:

```json
{
  "templateId": "lonely-dog"
}
```

`templateId` must be unique among animals and must not change after the template is published.

## Animal kind (`kind`)

`kind` is the kind of animal used when displaying the animal in the game.

For example:

```json
{
  "kind": "Dog"
}
```

Other values may include, for example:

```text
Cat
Owl
Pig
```

## Initial name (`initialDisplayName`)

`initialDisplayName` is the animal's name before the player gives it a home and a name of their own.

For example:

```text
Lonely Dog
Sad Cat
Lost Owl
```

`initialDisplayName` may be used in a message about an animal looking for a home:

> Lonely Dog is looking for a home.

After the animal moves in, the name given by the player is used.

For example, if the player names the dog Barbos and moves it into a house, the house description may display:

> Barbos the dog lives here.

Thus, `initialDisplayName` belongs to the animal template, while the name Barbos belongs to a particular player animal.

## Image

The animal template contains an image:

```json
{
  "sourceImageUrl": "https://example.org/lonely-dog.png"
}
```

The published catalog uses:

```json
{
  "imageKey": "animals/lonely-dog.webp"
}
```

The image belongs to the animal template and does not change when the player gives the animal a name of their own.

## Validation

Before opening a pull request, check:

* `templateId` is unique among animals;
* `initialDisplayName` is not empty;
* `kind` is not empty;
* `initialDisplayName` is suitable for a message about an animal looking for a home;
* the image is provided through `sourceImageUrl` or `imageKey`, rather than added to the repository as a binary file.
