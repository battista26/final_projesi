import 'package:final_projesi/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';
import 'dart:math';
import 'book_model.dart';

final TextEditingController summaryController = TextEditingController();

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Book> books = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  File? coverImageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    final dbHelper = DatabaseHelper();
    final dbBooks = await dbHelper.fetchBooks();
    setState(() {
      books = dbBooks;
    });
  }

  // Kapak resmi
  Future<void> kapakSec() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        coverImageFile = File(image.path); // Store the file path
      });
    }
  }

  void kitapEkle() async {
    if (coverImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a cover image')),
      );
      return;
    }

    final String id = Random().nextInt(100000).toString(); // Unique ID
    final newBook = Book(
      id: id,
      title: titleController.text,
      author: authorController.text,
      cover: coverImageFile!.path,
      summary: summaryController.text,
    );

    await DatabaseHelper().insertBook(newBook);

    setState(() {
      books.add(newBook);
    });

    titleController.clear();
    authorController.clear();
    summaryController.clear();
    coverImageFile = null;
    Navigator.pop(context); // Close the dialog
  }

  void kitapDuzenle(String id) async {
    final index = books.indexWhere((book) => book.id == id);
    if (index != -1) {
      books[index].title = titleController.text;
      books[index].author = authorController.text;
      books[index].summary = summaryController.text;
      books[index].cover = coverImageFile?.path ?? books[index].cover;

      await DatabaseHelper().updateBook(books[index]);

      setState(() {});
      titleController.clear();
      authorController.clear();
      summaryController.clear();
      coverImageFile = null;
      Navigator.pop(context); // Close the dialog
    }
  }

  void kitapSil(String id) async {
    await DatabaseHelper().deleteBook(id);
    setState(() {
      books.removeWhere((book) => book.id == id);
    });
  }

  void kitapBilgileri({Book? book}) {
    if (book != null) {
      titleController.text = book.title;
      authorController.text = book.author;
      summaryController.text = book.summary;
      coverImageFile = File(book.cover); // Load the cover file
    } else {
      titleController.clear();
      authorController.clear();
      summaryController.clear();
      coverImageFile = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book == null ? 'Kitap Ekle' : 'Kitap Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Başlık'),
                ),
                TextField(
                  controller: authorController,
                  decoration: InputDecoration(labelText: 'Yazar'),
                ),
                TextField(
                  controller: summaryController,
                  decoration: InputDecoration(labelText: 'Özet'),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: kapakSec,
                  child: Text('Kapak fotoğrafı seçin'),
                ),
                if (coverImageFile != null)
                  Image.file(
                    coverImageFile!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (book == null) {
                  kitapEkle();
                } else {
                  kitapDuzenle(book.id);
                }
              },
              child: Text(book == null ? 'Ekle' : 'Düzenle'),
            ),
          ],
        );
      },
    );
  }

  void ratingDiyalog(Book book) {
    double selectedRating = book.ratings.isNotEmpty
        ? book.ratings.last.toDouble()
        : 0.0; // Eğer değer yoksa 3.0, varsa son değeri al

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Değerlendir ${book.title}'),
          content: RatingBar.builder(
            initialRating: selectedRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              selectedRating = rating; // Değerlendirmeyi güncelle
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  book.ratings.add(selectedRating.toInt());
                });
                Navigator.pop(context);
              },
              child: Text('Değerlendir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kütüphane'),
      ),
      backgroundColor: const Color(0xFFFFF0DC),
      body: books.isEmpty
          ? Center(child: Text('Şuan kitap yok.'))
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(
                    book.title,
                    style: GoogleFonts.notoSans(
                      fontSize: 26,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RichText kullanma sebebim iki farklı renk kullanmak
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Yazar: ',
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: book.author,
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Özet: ',
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: book.summary,
                              style: GoogleFonts.notoSans(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  leading: book.cover.isNotEmpty
                      ? Image.file(
                          File(book.cover),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => kitapBilgileri(book: book),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => kitapSil(book.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.rate_review),
                        onPressed: () => ratingDiyalog(book),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => kitapBilgileri(),
        backgroundColor: Color(0xFFF0BB78),
        child: Icon(Icons.add),
      ),
    );
  }
}
