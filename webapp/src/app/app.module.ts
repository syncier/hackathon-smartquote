import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { NxBadgeModule } from '@aposin/ng-aquila/badge';
import { NxButtonModule } from '@aposin/ng-aquila/button';
import { NxCodeInputModule } from '@aposin/ng-aquila/code-input';
import { NxIconModule } from '@aposin/ng-aquila/icon';

import { HttpClientModule } from '@angular/common/http';
import { ConnectComponent } from './connect/connect.component';

@NgModule({
  declarations: [
    AppComponent,
    ConnectComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    NxBadgeModule,
    NxCodeInputModule,
    NxButtonModule,
    NxIconModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
