import { LightningElement } from 'lwc';

export default class IdsUtils extends LightningElement {
    reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }

    return (
        errors
            // Remove null/undefined items
            .filter((error) => !!error)
            // Extract an error message
            .map((error) => {
                // UI API and Apex errors
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                }
                // Page-level errors
                else if (
                    error.body &&
                    typeof error.body.message === 'string'
                ) {
                    return error.body.message;
                }
                // Field-level errors
                else if (
                    error.body &&
                    typeof error.body.output === 'object'
                ) {
                    let outputErrors = [];
                    let fieldErrors = error.body.output.fieldErrors;
                    let pageErrors = error.body.output.errors;
                    if (fieldErrors) {
                        outputErrors.push(
                            ...Object.values(fieldErrors).flat().map((e) => e.message)
                        );
                    }
                    if (pageErrors) {
                        outputErrors.push(...pageErrors.map((e) => e.message));
                    }
                    return outputErrors;
                }
                // Unknown error shape so just pass the HTTP status text
                else if (typeof error.statusText === 'string') {
                    return error.statusText;
                }
                // Unknown error shape so just return the JSON string
                return error.message || error.status || error.body || error;
            })
            // Flatten the array (for example, to turn [['a', 'b'], 'c'] into ['a', 'b', 'c'])
            .flat()
    );
}
}