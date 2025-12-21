import { Component, signal, input, output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RichTextEditorComponent } from '../rich-text-editor/rich-text-editor';

@Component({
  selector: 'app-editor',
  standalone: true,
  imports: [CommonModule, FormsModule, RichTextEditorComponent],
  template: `
    <div class="note-editor-container">
      <div class="editor-header">
        <input
          type="text"
          [value]="title()"
          (input)="onTitleChange($event)"
          placeholder="Note Title"
          class="title-input"
        />
        
        <div class="editor-tags">
          <div class="tags-container">
            @for (tag of tags(); track tag) {
              <span class="tag">
                {{ tag }}
                <button (click)="removeTag(tag)" class="tag-remove">×</button>
              </span>
            }
            <input
              type="text"
              #tagInput
              placeholder="Add tag..."
              (keyup.enter)="addTag(tagInput.value); tagInput.value=''"
              class="tag-input"
            />
          </div>
        </div>
      </div>
      
      <app-rich-text-editor
        [content]="content()"
        [placeholder]="'Write your note here...'"
        [showWordCount]="true"
        (contentChanged)="onContentChange($event)"
      ></app-rich-text-editor>
      
      <div class="editor-actions">
        <div class="left-actions">
          <button
            type="button"
            (click)="togglePin()"
            [class]="isPinned() ? 'btn-pinned' : 'btn-unpinned'"
          >
            {{ isPinned() ? '📌 Unpin' : '📌 Pin' }}
          </button>
          
          <select [value]="selectedFormat()" (change)="onFormatChange($event)" class="format-select">
            <option value="html">HTML</option>
            <option value="markdown">Markdown</option>
            <option value="plain">Plain Text</option>
          </select>
        </div>
        
        <div class="right-actions">
          <button type="button" (click)="onCancel()" class="btn-secondary">
            Cancel
          </button>
          <button type="button" (click)="onSave()" class="btn-primary">
            {{ noteId() ? 'Update' : 'Save' }} Note
          </button>
        </div>
      </div>
    </div>
  `,
  })
export class Editor {
  // Input signals
  noteId = input<string | null>(null);
  title = input('New Note');
  content = input('');
  tags = input<string[]>([]);
  isPinned = input(false);

  // Output events
  save = output<{ title: string; content: string; tags: string[]; isPinned: boolean }>();
  cancel = output<void>();

  // Local state
  currentTitle = signal(this.title());
  currentTags = signal(this.tags());
  currentIsPinned = signal(this.isPinned());
  selectedFormat = signal('html');

  onTitleChange(event: Event): void {
    const input = event.target as HTMLInputElement;
    this.currentTitle.set(input.value);
  }

  onContentChange(content: string): void {
    // Content is managed by the rich text editor component
  }

  addTag(tag: string): void {
    if (tag.trim() && !this.currentTags().includes(tag.trim())) {
      this.currentTags.update(tags => [...tags, tag.trim()]);
    }
  }

  removeTag(tagToRemove: string): void {
    this.currentTags.update(tags => tags.filter(tag => tag !== tagToRemove));
  }

  togglePin(): void {
    this.currentIsPinned.update(pinned => !pinned);
  }

  onFormatChange(event: Event): void {
    const select = event.target as HTMLSelectElement;
    this.selectedFormat.set(select.value);
    // TODO: Implement format conversion logic
  }

  onSave(): void {
    this.save.emit({
      title: this.currentTitle(),
      content: this.content(),
      tags: this.currentTags(),
      isPinned: this.currentIsPinned()
    });
  }

  onCancel(): void {
    this.cancel.emit();
  }
}