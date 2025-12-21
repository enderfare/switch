import { Routes } from '@angular/router';
import { Editor } from './components/editor/editor';

export const routes: Routes = [
    { path: 'home', component: Editor },

    { path: '**', redirectTo: 'home' } // Wildcard route for 404
];
