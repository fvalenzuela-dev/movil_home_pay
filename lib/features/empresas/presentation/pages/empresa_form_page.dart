import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../admin/domain/entities/category.dart';
import '../../../admin/presentation/bloc/category_bloc.dart';
import '../../../admin/presentation/bloc/category_event.dart';
import '../../../admin/presentation/bloc/category_state.dart';
import '../../domain/entities/empresa.dart';
import '../bloc/empresa_bloc.dart';

/// Form page for creating or editing an empresa
class EmpresaFormPage extends StatefulWidget {
  final String? empresaId; // null for create mode

  const EmpresaFormPage({super.key, this.empresaId});

  @override
  State<EmpresaFormPage> createState() => _EmpresaFormPageState();
}

class _EmpresaFormPageState extends State<EmpresaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isEditMode = false;
  int _selectedCategoryId = 0;
  Empresa? _existingEmpresa;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.empresaId != null;
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadEmpresa();
      });
    }
    // Load categories for dropdown
    context.read<CategoryBloc>().add(const CategoriesLoadRequested());
  }

  void _loadEmpresa() {
    context.read<EmpresaBloc>().add(EmpresaDetailRequested(widget.empresaId!));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateForm(Empresa empresa) {
    _existingEmpresa = empresa;
    _nameController.text = empresa.name;
    _websiteController.text = empresa.website ?? '';
    _phoneController.text = empresa.phone ?? '';
    setState(() {
      _selectedCategoryId = empresa.categoryId > 0 ? empresa.categoryId : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Editar Empresa' : 'Nueva Empresa'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: const [],
      ),
      body: BlocConsumer<EmpresaBloc, EmpresaState>(
        listener: (context, state) {
          if (state is EmpresaDetailLoaded && _isEditMode) {
            _populateForm(state.empresa);
          }
          if (state is EmpresaOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          }
          if (state is EmpresaError) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (_isEditMode && state is EmpresaLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildForm();
        },
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Name field
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre *',
              hintText: 'Nombre de la empresa',
              prefixIcon: Icon(Icons.business),
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El nombre es requerido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Category dropdown
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              final List<Category> categories;
              if (state is CategoriesLoaded) {
                categories = state.categories;
              } else {
                categories = [];
              }

              return DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId > 0 ? _selectedCategoryId : null,
                decoration: const InputDecoration(
                  labelText: 'Categoría *',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Seleccione una categoría'),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<int>(
                    value: 0,
                    child: Text('Sin categoría'),
                  ),
                  ...categories.map((Category c) => DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(c.name),
                      )),
                ],
                onChanged: (int? value) {
                  setState(() {
                    _selectedCategoryId = value ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null || value <= 0) {
                    return 'La categoría es requerida';
                  }
                  return null;
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Website field (optional)
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(
              labelText: 'Sitio Web (opcional)',
              hintText: 'https://ejemplo.com',
              prefixIcon: Icon(Icons.language),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final trimmed = value.trim();
                if (!trimmed.startsWith('http://') &&
                    !trimmed.startsWith('https://')) {
                  return 'La URL debe comenzar con http:// o https://';
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone field (optional)
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Teléfono (opcional)',
              hintText: '+56 9xxxxxxx',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primarySeed,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(_isEditMode ? 'Guardar Cambios' : 'Crear Empresa'),
            ),
          ),
        ],
      ),
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final categoryId = _selectedCategoryId;
    final website = _websiteController.text.trim().isEmpty
        ? null
        : _websiteController.text.trim();
    final phone = _phoneController.text.trim().isEmpty
        ? null
        : _phoneController.text.trim();

    if (_isEditMode && _existingEmpresa != null) {
      final updatedEmpresa = _existingEmpresa!.copyWith(
        name: name,
        categoryId: categoryId,
        website: website,
        phone: phone,
      );
      context.read<EmpresaBloc>().add(EmpresaUpdateRequested(updatedEmpresa));
    } else {
      // Create mode - use empty ID and authUserId placeholder
      // The actual authUserId should come from the auth state in a real app
      const empresa = Empresa(
        id: '', // Will be assigned by backend
        authUserId: '', // Will be assigned from auth context
        categoryId: 0,
        name: '',
      );
      final newEmpresa = empresa.copyWith(
        categoryId: categoryId,
        name: name,
        website: website,
        phone: phone,
      );
      context.read<EmpresaBloc>().add(EmpresaCreateRequested(newEmpresa));
    }
  }

}