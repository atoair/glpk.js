import { Component } from '@angular/core';
import { GLPK, LP } from '../../../../glpk.js'

declare const glpkPromise: Promise<GLPK>;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'glpk';
  constructor() {
    glpkPromise
      .then(glpk => {

        let lp: LP = {
          name: 'LP',
          objective: {
            direction: glpk.GLP_MAX,
            name: 'obj',
            vars: [
              { name: 'x1', coef: 0.6 },
              { name: 'x2', coef: 0.5 }
            ]
          },
          subjectTo: [
            {
              name: 'cons1',
              vars: [
                { name: 'x1', coef: 1.0 },
                { name: 'x2', coef: 2.0 }
              ],
              bnds: { type: glpk.GLP_UP, ub: 1.0, lb: 0.0 }
            },
            {
              name: 'cons2',
              vars: [
                { name: 'x1', coef: 3.0 },
                { name: 'x2', coef: 1.0 }
              ],
              bnds: { type: glpk.GLP_UP, ub: 2.0, lb: 0.0 }
            }
          ]
        };

        console.log(
          glpk.solve(lp, glpk.GLP_MSG_ALL)
        );

      })
      .catch(err => console.log(err));
  }
}
