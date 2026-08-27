import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

enum ContentType { video, lesson, quiz }

class ContentItem {
  final String id;
  String title;
  String subject;
  ContentType type;
  String detail;
  String description;
  String dateAdded;
  String? filePath;

  ContentItem({
    required this.id,
    required this.title,
    required this.subject,
    required this.type,
    required this.detail,
    this.description = '',
    required this.dateAdded,
    this.filePath,
  });
}

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  final List<ContentItem> _contents = [
    ContentItem(
      id: '1',
      title: 'Fonctions Quadratiques',
      subject: 'Mathématiques',
      type: ContentType.video,
      detail: '24 mins',
      description: 'Introduction aux équations du second degré.',
      dateAdded: '12/05/23',
    ),
    ContentItem(
      id: '2',
      title: 'Lois de Newton',
      subject: 'Physique',
      type: ContentType.lesson,
      detail: '8 pages',
      description: 'Explication des 3 lois fondamentales de la dynamique.',
      dateAdded: '12/05/23',
    ),
    ContentItem(
      id: '3',
      title: 'Quiz de Géométrie',
      subject: 'Mathématiques',
      type: ContentType.quiz,
      detail: '15 questions',
      description: 'Évaluation rapide sur les théorèmes de Pythagore et Thalès.',
      dateAdded: '12/05/23',
    ),
    ContentItem(
      id: '4',
      title: 'Physique-Chimie',
      subject: 'Sciences',
      type: ContentType.lesson,
      detail: '12 pages',
      description: 'Fiche résumé sur les réactions chimiques.',
      dateAdded: '14/05/23',
    ),
  ];

  String _searchQuery = '';
  ContentType? _selectedFilter;

  int get _videoCount => _contents.where((c) => c.type == ContentType.video).length;
  int get _lessonCount => _contents.where((c) => c.type == ContentType.lesson).length;
  int get _quizCount => _contents.where((c) => c.type == ContentType.quiz).length;

  List<ContentItem> get _filteredContents {
    return _contents.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subject.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == null || item.type == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _deleteContent(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer le contenu"),
        content: const Text("Voulez-vous vraiment supprimer ce cours ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _contents.removeWhere((item) => item.id == id);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddOrEditContentModal(BuildContext context, {ContentItem? itemToEdit, ContentType? defaultType}) {
    final titleController = TextEditingController(text: itemToEdit?.title ?? '');
    final detailController = TextEditingController(text: itemToEdit?.detail ?? '');
    final descriptionController = TextEditingController(text: itemToEdit?.description ?? '');
    
    String selectedSubject = itemToEdit?.subject ?? 'Mathématiques';
    ContentType selectedType = itemToEdit?.type ?? defaultType ?? ContentType.video;
    String? selectedFileName = itemToEdit?.filePath?.split('/').last;
    String? pickedFilePath = itemToEdit?.filePath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickFile() async {
              FileType fileType = selectedType == ContentType.video ? FileType.video : FileType.custom;
              List<String>? extensions = selectedType == ContentType.video ? null : ['pdf'];

              FilePickerResult? result = await FilePicker.instance.pickFiles(
                type: fileType,
                allowedExtensions: extensions,
              );

              if (result != null && result.files.single.path != null) {
                setModalState(() {
                  pickedFilePath = result.files.single.path;
                  selectedFileName = result.files.single.name;
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          itemToEdit == null ? "Ajouter du Contenu" : "Éditer le Contenu",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Titre de la leçon / vidéo",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedSubject,
                            items: ['Mathématiques', 'Physique', 'Sciences', 'SVT']
                                .map((s) => DropdownMenuItem<String>(
                                      value: s,
                                      child: Text(s),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => selectedSubject = val);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Matière",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<ContentType>(
                            initialValue: selectedType,
                            items: const [
                              DropdownMenuItem<ContentType>(
                                value: ContentType.video,
                                child: Text("Vidéo"),
                              ),
                              DropdownMenuItem<ContentType>(
                                value: ContentType.lesson,
                                child: Text("Leçon"),
                              ),
                              DropdownMenuItem<ContentType>(
                                value: ContentType.quiz,
                                child: Text("Quiz"),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => selectedType = val);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: "Type",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: detailController,
                      decoration: InputDecoration(
                        labelText: "Durée ou Nombre de pages (ex: 24 mins / 8 pages)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Description du cours",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: pickFile,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selectedType == ContentType.video ? Icons.video_file : Icons.picture_as_pdf,
                              color: const Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                selectedFileName ?? "Importer le fichier (${selectedType == ContentType.video ? 'Vidéo' : 'PDF'})",
                                style: TextStyle(
                                  color: selectedFileName == null ? Colors.grey[700] : Colors.black,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.upload_file, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            setState(() {
                              if (itemToEdit != null) {
                                itemToEdit.title = titleController.text;
                                itemToEdit.subject = selectedSubject;
                                itemToEdit.type = selectedType;
                                itemToEdit.detail = detailController.text;
                                itemToEdit.description = descriptionController.text;
                                itemToEdit.filePath = pickedFilePath;
                              } else {
                                _contents.insert(
                                  0,
                                  ContentItem(
                                    id: DateTime.now().toString(),
                                    title: titleController.text,
                                    subject: selectedSubject,
                                    type: selectedType,
                                    detail: detailController.text.isEmpty
                                        ? (selectedType == ContentType.video ? "15 mins" : "5 pages")
                                        : detailController.text,
                                    description: descriptionController.text,
                                    filePath: pickedFilePath,
                                    dateAdded: "Aujourd'hui",
                                  ),
                                );
                              }
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          itemToEdit == null ? "Publier le contenu" : "Enregistrer les modifications",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("P+", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF2563EB), size: 28),
            onPressed: () => _showAddOrEditContentModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: "Rechercher une vidéo, une leçon...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Icon(Icons.tune, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard("VIDÉOS", _videoCount, "Vidéos", const Color(0xFF2563EB), ContentType.video),
                const SizedBox(width: 10),
                _buildStatCard("LEÇONS", _lessonCount, "Leçons", const Color(0xFF10B981), ContentType.lesson),
                const SizedBox(width: 10),
                _buildStatCard("QUIZ", _quizCount, "Quiz", const Color(0xFFD97706), ContentType.quiz),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Ajouter du Contenu", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Publiez directement une leçon ou une vidéo pour vos élèves", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickAddCard(
                    title: "Ajouter une Vidéo",
                    subtitle: "Niveau, durée, lien streaming & description",
                    icon: Icons.play_arrow_rounded,
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFEFF6FF),
                    onTap: () => _showAddOrEditContentModal(context, defaultType: ContentType.video),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAddCard(
                    title: "Ajouter une Leçon",
                    subtitle: "Support PDF, fiches résumé & chapitres",
                    icon: Icons.picture_as_pdf,
                    color: const Color(0xFF059669),
                    bgColor: const Color(0xFFECFDF5),
                    onTap: () => _showAddOrEditContentModal(context, defaultType: ContentType.lesson),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("RÉCEMMENT AJOUTÉS", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
                Text("Voir tout", style: TextStyle(color: Color(0xFF2563EB), fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredContents.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.70,
              ),
              itemBuilder: (context, index) {
                return _buildContentCard(_filteredContents[index]);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: "Mon Espace"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Analyses"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Mon Profil"),
        ],
      ),
    );
  }

  Widget _buildStatCard(String tag, int count, String label, Color color, ContentType type) {
    final isSelected = _selectedFilter == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = isSelected ? null : type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text("[$tag]", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 8),
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 0.7,
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      backgroundColor: color.withValues(alpha: 0.15),
                    ),
                    Text("$count", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAddCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[700], fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(ContentItem item) {
    Color cardColor;
    IconData mainIcon;
    IconData topIcon;

    switch (item.type) {
      case ContentType.video:
        cardColor = const Color(0xFF2563EB);
        mainIcon = Icons.science_outlined;
        topIcon = Icons.play_arrow;
        break;
      case ContentType.lesson:
        cardColor = const Color(0xFF10B981);
        mainIcon = item.subject == 'Sciences' ? Icons.science_outlined : Icons.menu_book;
        topIcon = Icons.description;
        break;
      case ContentType.quiz:
        cardColor = const Color(0xFFD97706);
        mainIcon = Icons.help_outline;
        topIcon = Icons.help_outline;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 75,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Stack(
              children: [
                Center(child: Icon(mainIcon, color: Colors.white, size: 36)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(topIcon, color: Colors.white, size: 12),
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                    onPressed: () => _deleteContent(item.id),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  "${item.type == ContentType.video ? 'Vidéo' : item.type == ContentType.lesson ? 'Leçon' : 'Quiz'}, ${item.detail}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey[700], fontSize: 10, fontStyle: FontStyle.italic),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text("Mise en ligne: ${item.dateAdded}", style: TextStyle(color: Colors.grey[400], fontSize: 9)),
                const SizedBox(height: 6),
                const Divider(height: 1),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(35, 24)),
                      child: const Text("Voir", style: TextStyle(fontSize: 11, color: Color(0xFF2563EB))),
                    ),
                    const Text("|", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => _showAddOrEditContentModal(context, itemToEdit: item),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(35, 24)),
                      child: const Text("Éditer", style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}