
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/resume_bloc.dart';
import '../bloc/resume_event.dart';
import '../bloc/resume_state.dart';
import '../widgets/bullet_section.dart';
import '../widgets/score_circle.dart';

class ResumeCheckerPage extends StatefulWidget {
const ResumeCheckerPage({super.key});

@override
State<ResumeCheckerPage> createState() => _ResumeCheckerPageState();
}

class _ResumeCheckerPageState extends State<ResumeCheckerPage> {
final _jdController = TextEditingController();

@override
void dispose() {
_jdController.dispose();
super.dispose();
}

Future<void> _pickFile() async {
final result = await FilePicker.platform.pickFiles(
type: FileType.custom,
allowedExtensions: ['pdf'],
);

final file = result?.files.single;

if (file == null || file.path == null || !mounted) return;

context.read<ResumeBloc>().add(
ResumeFileSelected(
path: file.path!,
fileName: file.name,
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('ResumeAI'),
actions: [
IconButton(
tooltip: 'Reset',
icon: const Icon(Icons.refresh),
onPressed: () {
_jdController.clear();
context.read<ResumeBloc>().add(const ResumeReset());
},
),
],
),
body: BlocConsumer<ResumeBloc, ResumeState>(
listenWhen: (previous, current) =>
current.status == ResumeStatus.failure &&
current.errorMessage != null,
listener: (context, state) {
ScaffoldMessenger.of(context)
..hideCurrentSnackBar()
..showSnackBar(
SnackBar(
content: Text(state.errorMessage!),
),
);
},
builder: (context, state) {
final busy =
state.status == ResumeStatus.extracting ||
state.status == ResumeStatus.analyzing;

return ListView(
padding: const EdgeInsets.all(16),
children: [
Card(
child: ListTile(
leading: const Icon(
Icons.picture_as_pdf,
size: 32,
),
title: Text(
state.fileName ?? 'Select a resume (PDF)',
),
subtitle:
state.status == ResumeStatus.extracting
? const Text('Extracting text...')
    : state.resumeText != null
? const Text('Ready ✓')
    : null,
trailing: FilledButton.tonal(
onPressed: busy ? null : _pickFile,
child: const Text('Upload'),
),
),
),
const SizedBox(height: 12),
TextField(
controller: _jdController,
maxLines: 4,
decoration: const InputDecoration(
labelText: 'Job description (optional)',
hintText:
'Paste the target job description for a better match analysis.',
border: OutlineInputBorder(),
),
),
const SizedBox(height: 12),
FilledButton.icon(
onPressed: state.canAnalyze
? () => context.read<ResumeBloc>().add(
AnalyzeRequested(
jobDescription: _jdController.text,
),
)
    : null,
icon: state.status == ResumeStatus.analyzing
? const SizedBox(
width: 18,
height: 18,
child: CircularProgressIndicator(
strokeWidth: 2,
),
)
    : const Icon(Icons.auto_awesome),
label: Text(
state.status == ResumeStatus.analyzing
? 'Analyzing...'
    : 'Check Resume',
),
),
if (state.analysis != null) ..._buildResult(state),
],
);
},
),
);
}

List<Widget> _buildResult(ResumeState state) {
final a = state.analysis!;

return [
const SizedBox(height: 24),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
ScoreCircle(
label: 'Overall',
score: a.overallScore,
),
ScoreCircle(
label: 'ATS',
score: a.atsScore,
),
],
),
Card(
margin: const EdgeInsets.only(top: 16),
child: Padding(
padding: const EdgeInsets.all(16),
child: Text(a.summary),
),
),
BulletSection(
title: 'Strengths',
icon: Icons.thumb_up_alt_outlined,
color: Colors.green,
items: a.strengths,
),
BulletSection(
title: 'Weaknesses',
icon: Icons.warning_amber_rounded,
color: Colors.orange,
items: a.weaknesses,
),
BulletSection(
title: 'Missing Keywords',
icon: Icons.key,
color: Colors.red,
items: a.missingKeywords,
),
BulletSection(
title: 'Suggestions',
icon: Icons.lightbulb_outline,
color: Colors.blue,
items: a.suggestions,
),
const SizedBox(height: 24),
];
}
}
