import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Note {
  id: string;
  title: string;
  content: string;
  tags: string[];
  isPinned: boolean;
  createdAt: Date;
  updatedAt: Date;
  authorId: string;
  sectionId: string;
}

@Injectable({
  providedIn: 'root'
})
export class NoteService {
  private apiUrl = 'http://localhost:8080/api'; // Update with your backend URL

  // Using Angular 21 Signals for local state management [citation:9]
  private notes = signal<Note[]>([]);
  private currentNote = signal<Note | null>(null);

  notes$ = this.notes.asReadonly();
  currentNote$ = this.currentNote.asReadonly();

  constructor(private http: HttpClient) { }

  // Fetch notes for a section
  getNotes(sectionId: string): Observable<Note[]> {
    return this.http.get<Note[]>(`${this.apiUrl}/sections/${sectionId}/notes`);
  }

  // Create a new note
  createNote(sectionId: string, note: Partial<Note>): Observable<Note> {
    return this.http.post<Note>(`${this.apiUrl}/sections/${sectionId}/notes`, note);
  }

  // Update existing note
  updateNote(noteId: string, updates: Partial<Note>): Observable<Note> {
    return this.http.put<Note>(`${this.apiUrl}/notes/${noteId}`, updates);
  }

  // Delete note
  deleteNote(noteId: string): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/notes/${noteId}`);
  }

  // Share note (generate shareable link)
  shareNote(noteId: string): Observable<{ shareLink: string }> {
    return this.http.post<{ shareLink: string }>(`${this.apiUrl}/notes/${noteId}/share`, {});
  }

  // Get note version history
  getNoteHistory(noteId: string): Observable<Note[]> {
    return this.http.get<Note[]>(`${this.apiUrl}/notes/${noteId}/history`);
  }

  // Local state management methods
  setNotes(notes: Note[]): void {
    this.notes.set(notes);
  }

  setCurrentNote(note: Note | null): void {
    this.currentNote.set(note);
  }

  addNote(note: Note): void {
    this.notes.update(notes => [...notes, note]);
  }

  removeNote(noteId: string): void {
    this.notes.update(notes => notes.filter(note => note.id !== noteId));
  }

  updateLocalNote(updatedNote: Note): void {
    this.notes.update(notes =>
      notes.map(note => note.id === updatedNote.id ? updatedNote : note)
    );
  }
}