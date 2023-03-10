// ignore_for_file: non_constant_identifier_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';

class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  List<CategoryAndProducts> categories = [];
  final categoriesService = GetCategoriesServices();
  Future refresh() async {
    setState(() => categories.clear());
    await categoriesService.getCategories();
    setState(() {
      categories = categoriesService.categories;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (categoriesService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Categories or =>'),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'adminProducts');
                },
                child: const Icon(
                  Icons.shopify,
                  color: Colors.white,
                )),
            TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'insertCategory'),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Icon(Icons.add, color: Colors.white)),
          ],
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: const ExampleExpandableFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: RefreshIndicator(
          onRefresh: () async {
            refresh();
            Navigator.pushReplacementNamed(context, 'adminCategories');
          },
          child: ListView.builder(
            itemBuilder: (context, index) {
              return MySlidable(
                id: categories[index].id,
                index: index,
                tit: categories[index].name,
                desc: categories[index].description,
              );
            },
            itemCount: categories.length,
          )),
    );
  }
}

class MySlidable extends StatelessWidget {
  final String tit;
  final String desc;
  final int id;
  final int index;
  const MySlidable({
    Key? key,
    required this.tit,
    required this.desc,
    required this.id,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deleteCategoryService =
        Provider.of<DeleteCategoryAndProductsServices>(context);
    final deleteProductsService =
        Provider.of<DeleteProductsOfCategoryServices>(context);
    return Slidable(

        // Specify a key if the Slidable is dismissible.
        key: const ValueKey(0),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {}),
          dragDismissible: false,

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (BuildContext _) async {
                await CoolAlert.show(
                  context: context,
                  type: CoolAlertType.warning,
                  title: 'Are you sure?',
                  text: "Are you sure you want to delete this category?",
                  showCancelBtn: true,
                  confirmBtnColor: Colors.red,
                  confirmBtnText: 'Delete',
                  onConfirmBtnTap: () {
                    deleteCategoryService.deleteDeleteCategoryAndProducts(id);
                    Navigator.pushReplacementNamed(context, 'adminCategories');
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Category',
            ),
            SlidableAction(
              onPressed: (BuildContext context) {
                Navigator.pushReplacementNamed(context, 'updateCategory',
                    arguments: id);
              },
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.manage_accounts_rounded,
              label: 'Edit',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            Visibility(
              visible: true,
              child: SlidableAction(
                onPressed: (BuildContext _) async {
                  await CoolAlert.show(
                    context: context,
                    type: CoolAlertType.warning,
                    title: 'Are you sure?',
                    text: "Are you sure you want to delete these products?",
                    showCancelBtn: true,
                    confirmBtnColor: Colors.red,
                    confirmBtnText: 'Delete',
                    onConfirmBtnTap: () {
                      deleteProductsService.deleteDeleteProductsOfCategory(id);
                      Navigator.pushReplacementNamed(
                          context, 'adminCategories');
                    },
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Products',
              ),
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: ListTile(
          title: Text(tit),
          subtitle: Text(desc),
        ));
  }

  static void goview(String route, BuildContext context) {
    Navigator.pushNamed(context, route);
  }
}
