import { Component, Input, Output, EventEmitter, signal, input, output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AngularEditorModule, AngularEditorConfig } from '@kolkov/angular-editor';

@Component({
  selector: 'app-rich-text-editor',
  standalone: true,
  imports: [CommonModule, FormsModule, AngularEditorModule],
  template: `
    <div class="editor-container" [class.compact]="compact()">
      <angular-editor
        [config]="editorConfig()"
        [(ngModel)]="content"
        (ngModelChange)="onContentChange($event)"
        [placeholder]="placeholder()"
        [disabled]="disabled()"
        class="rich-text-editor"
      ></angular-editor>
      
      @if (showWordCount()) {
        <div class="editor-footer">
          <span class="text-xs text-gray-500">
            Words: {{ wordCount() }} | Characters: {{ characterCount() }}
          </span>
        </div>
      }
    </div>
  `,
  
})
export class RichTextEditorComponent {
  // Input signals (Angular 21 recommended approach)
  content = input('');
  placeholder = input('Start typing...');
  disabled = input(false);
  compact = input(false);
  showWordCount = input(true);

  // Configuration with sensible defaults
  editorConfig = signal<AngularEditorConfig>({
    editable: true,
    spellcheck: true,
    height: 'auto',
    minHeight: '200px',
    maxHeight: 'auto',
    width: 'auto',
    minWidth: '0',
    translate: 'yes',
    enableToolbar: true,
    showToolbar: true,
    placeholder: this.placeholder(),
    defaultParagraphSeparator: 'p',
    defaultFontName: 'Arial',
    defaultFontSize: '3',
    fonts: [
      { class: 'font-sans', name: 'Sans Serif' },
      { class: 'font-serif', name: 'Serif' },
      { class: 'font-mono', name: 'Monospace' }
    ],
    customClasses: [
      {
        name: 'quote',
        class: 'quote',
      },
      {
        name: 'highlight',
        class: 'highlight',
      },
      {
        name: 'small-text',
        class: 'text-sm',
      },
      {
        name: 'large-text',
        class: 'text-lg',
      }
    ],
    uploadUrl: 'v1/image',
    uploadWithCredentials: false,
    sanitize: true,
    toolbarPosition: 'top',
    toolbarHiddenButtons: [
      [
        'customClasses',
        'insertImage',
        'insertVideo',
        'toggleEditorMode'
      ]
    ]
  });

  // Output events
  contentChanged = output<string>();

  // Computed signals
  wordCount = signal(0);
  characterCount = signal(0);

  constructor() {
    // Initialize counts
    this.updateCounts(this.content());
  }

  onContentChange(newContent: string): void {
    this.updateCounts(newContent);
    this.contentChanged.emit(newContent);
  }

  private updateCounts(content: string): void {
    const text = this.stripHtml(content);
    this.wordCount.set(text.split(/\s+/).filter(word => word.length > 0).length);
    this.characterCount.set(text.length);
  }

  private stripHtml(html: string): string {
    const tmp = document.createElement('div');
    tmp.innerHTML = html;
    return tmp.textContent || tmp.innerText || '';
  }
}