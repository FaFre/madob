# Madob Example

## Introduction

In this example we use two Madob objects, to lets say, get some daily tasks organized.

## Getting started

To get started we need to create two `abstract` classes: `IProject` and `ITask`.
`IProject` to `ITask` stands in a one-to-many relationship (One `IProject` is related to n `ITask`)

[`IProject`](lib/data/objects/project.dart):

```dart
@MadobType(typeId: 0)
abstract class IProject implements IKey {
  @override
  String get managedKey;

  @MadobGetter(1)
  Future<String> get title;
  @MadobSetter(1)
  Future<void> setTitle(String newTitle);
}
```

[`ITask`](lib/data/objects/task.dart):

```dart
@MadobType(typeId: 1)
abstract class ITask implements IKey {
  @override
  String get managedKey;

  @MadobGetter(1)
  Future<String> get title;
  @MadobGetter(2)
  Future<IProject> get project;

  @MadobSetter(1)
  Future<void> setTitle(String newTitle);
  @MadobSetter(2, referencedMadobObject: 'IProject')
  Future<void> setProject(IProject newProject);
}
```

To get everything generated just run `pub run build_runner build` now.

`IProject` will compile to three classes:

1. `MadobProject` - This is the only relevant class you will use when interacting with Madob.
2. `Project` - Unmanaged Hive data class. When using Madob, you wont use it directly.
3. `ProjectAdapter` - Hive adapter which will be used by Madob/Hive internally.

Basically `Project` and `ProjectAdapter` are helper classes you can ignore.

### Explanation

Each `class` has to be annotated with `MadobType` and a unique `typeId` to qualify it for code generation.

To distinct elements Madob uses `managedKey` which represents an Uuid. Because of that you need to implement `IKey` and generate the `managedKey` override.

Madob expects an getter-setter pair for each property which is annotated with `MadobGetter` and `MadobSetter`, linked by a shared Id (first parameter). If the property is linked to another Madob-object you have to specify the generated Hive class e.g. `IProject` in the named parameter `referencedMadobObject`. You are also able to link unmanaged `HiveObject`'s instead of managed ones via the named `referencedHiveObject` parameter (in case you have mixed code).

## Usage

Take a look into the [example](lib/example.dart) there is a complete example, also showcasing the synchronization:

```dart
// Directory to store the box(-files) in
  final directory = await PathProvider().getTempDirectory();

  // Register our adapter and define the box name
  // where eveything is going to be saved in
  BoxRepository.init(directory.path);
  BoxRepository.register('projectBox', ProjectAdapter());
  BoxRepository.register('taskBox', TaskAdapter());

  // generate two unique Id's
  final taskid = StrongUuid().generate();
  final projectId = StrongUuid().generate();

  print('Id for Task: $taskid');
  print('Id for Project: $projectId');

  // Create a new Task and initialize it with the generated Id
  final task = ManagedTask();
  await task.initialize(() => Task(taskid));

  // Create a Project and directly assign it to our Task
  await task.setProject(Project(projectId));

  // Create a duplicate instance of Project at thsi point,
  // to proof sync via projectId later
  final project = ManagedProject();
  await project.initialize(() => Project(projectId));

  // Just perform a simple get/set operation
  await task.setTitle('Test Task');
  print('After .setTitle(): ${await task.title}');

  // Close both boxes to free ressources or simulate an app close
  await BoxRepository.closeBox<Task>();
  await BoxRepository.closeBox<Project>();

  // Set title through closed task
  await (await task.project).setTitle('Test Project');
  // Just mix things up and replace the underlying Project instance
  await task.setProject(project);

  // Close the handle
  await BoxRepository.closeBox<Project>();

  // create a new instance of Project with our defined Id
  final regainedProject = ManagedProject();
  await regainedProject.initialize(() => Project(projectId));

  // Let's see if everything keeps synchronized:
  print('title of project set through task: ${await regainedProject.title}');
  print('title of project through untouched instance: ${await project.title}');
  print('title of project through task: ${await (await task.project).title}');
```
