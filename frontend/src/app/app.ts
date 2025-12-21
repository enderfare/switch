import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { Editor } from './components/editor/editor';


@Component({
  selector: 'app-root',
  imports: [RouterOutlet, Editor],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('Switch - Productivity App');

  // Example note data
  noteContent = signal(`<h2>Welcome to Switch!</h2>
<p>This is a <strong>rich text editor</strong> integrated into your productivity application.</p>
<ul>
  <li>Create beautiful notes</li>
  <li>Organize with tags</li>
  <li>Collaborate with team members</li>
</ul>
<p>Start by editing this content or create a new note!</p>`);

  noteTags = signal(['welcome', 'getting-started', 'documentation']);

  onNoteSaved(data: { title: string; content: string; tags: string[]; isPinned: boolean }): void {
    console.log('Note saved:', data);
    // In a real app, you would save to your backend here
    // For now, just update the signals
    this.noteContent.set(data.content);
    this.noteTags.set(data.tags);

    // Show success message
    alert(`Note "${data.title}" saved successfully!`);
  }

  onNoteCancelled(): void {
    console.log('Note editing cancelled');
    // Navigate back or close editor
  }
}