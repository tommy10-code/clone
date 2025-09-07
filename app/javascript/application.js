// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import { Autocomplete } from 'stimulus-autocomplete'  // 追加

const application = Application.start() // 追加
application.register('autocomplete', Autocomplete) // 追加