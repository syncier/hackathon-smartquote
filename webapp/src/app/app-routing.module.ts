import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {ConnectComponent} from './connect/connect.component';

const routes: Routes = [
  { path: 'connect', component: ConnectComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
