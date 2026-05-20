import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, this.task});

  final TaskModel? task;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late bool _completed;
  bool _isSaving = false;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _completed = widget.task?.completed ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final taskProvider = context.read<TaskProvider>();

    try {
      if (_isEditing) {
        await taskProvider.updateTask(
          widget.task!.copyWith(
            title: _titleController.text.trim(),
            completed: _completed,
          ),
        );
      } else {
        await taskProvider.addTask(
          title: _titleController.text,
          completed: _completed,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Task updated' : 'Task added')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Update Task' : 'Add Task'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _titleController,
                  label: 'Task title',
                  hintText: 'Complete Flutter Test',
                  prefixIcon: Icons.title,
                  validator: (value) => Validators.requiredText(value, 'Title'),
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: const Text('Completed'),
                  subtitle: Text(
                    _completed ? 'Marked as completed' : 'Marked as pending',
                  ),
                  value: _completed,
                  onChanged: (value) => setState(() => _completed = value),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: _isEditing ? 'Update Task' : 'Add Task',
                  icon: _isEditing ? Icons.save_outlined : Icons.add_task,
                  isLoading: _isSaving,
                  onPressed: _saveTask,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
