import { Controller } from "stimulus"

export default class extends Controller {
    reset(event) {
        const form = event.target
        form.reset()
    }
}