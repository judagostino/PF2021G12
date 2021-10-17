import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field'; 
import { NgModule } from '@angular/core';
import {MatIconModule} from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatSelectModule } from '@angular/material/select';
import {MatCardModule} from '@angular/material/card';
import {MatDatepickerModule} from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import {MatCheckboxModule} from '@angular/material/checkbox';


@NgModule({
  imports: [
    MatInputModule,
    MatFormFieldModule,
    MatIconModule,
    MatButtonModule,
    MatSelectModule,
    MatCardModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatCheckboxModule
  ],
  exports: [
    MatInputModule,
    MatFormFieldModule,
    MatIconModule,
    MatButtonModule,
    MatSelectModule,
    MatCardModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatCheckboxModule
  ]
})
export class MaterialModule { }