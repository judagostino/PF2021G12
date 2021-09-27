import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ABMEventsComponent } from './pages/abm-events/abm-events.component';
import { CalendarComponent } from './pages/calendar/calendar.component';
import { HomeComponent } from './pages/home/home.component';
import { LoginComponent } from './pages/login/login.component';
import { RegisterComponent } from './pages/register/register.component';

const routes: Routes = [
  {path:'login',component:LoginComponent},
  {path:'register',component:RegisterComponent},
  {path:'home',component:HomeComponent},
  {path:'events',component:ABMEventsComponent},
  {path:'calendar',component:CalendarComponent},
  {path:'**',redirectTo:"home"}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
