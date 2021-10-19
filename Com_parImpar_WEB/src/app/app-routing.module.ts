import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ABMEventsComponent } from './pages/abm-events/abm-events.component';
import { ABMPostsComponent } from './pages/abm-posts/abm-posts.component';
import { CalendarComponent } from './pages/calendar/calendar.component';
import { ChangePasswordComponent } from './pages/change-password/change-password.component';
import { ConfirmUserComponent } from './pages/confirm-user/confirm-user.component';
import { DenyRecoverComponent } from './pages/deny-recover/deny-recover.component';
import { EventsInfoComponent } from './pages/events-info/events-info.component';
import { HomeComponent } from './pages/home/home.component';
import { LoginComponent } from './pages/login/login.component';
import { PostsInfoComponent } from './pages/posts-info/posts-info.component';
import { ProfileComponent } from './pages/profile/profile.component';
import { RecoverPassordComponent } from './pages/recover-passord/recover-passord.component';
import { RegisterComponent } from './pages/register/register.component';
import { SearchComponent } from './pages/search/search.component';

const routes: Routes = [
  {path:'login',component: LoginComponent},
  {path:'register',component: RegisterComponent},
  {path:'home',component: HomeComponent},
  {path:'events',component: ABMEventsComponent},
  {path:'posts',component: ABMPostsComponent},
  {path:'calendar',component: CalendarComponent},
  {path:'search',component: SearchComponent},
  {path:'posts-info/:id',component: PostsInfoComponent},
  {path:'events-info/:id',component: EventsInfoComponent},
  {path:'profile/:id',component: ProfileComponent},
  {path:'user/recover',component: RecoverPassordComponent},
  {path:'user/change',component: ChangePasswordComponent},
  {path:'user/confirm',component: ConfirmUserComponent},
  {path:'user/cancel',component: DenyRecoverComponent},
  {path:'**',redirectTo:"home"}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
